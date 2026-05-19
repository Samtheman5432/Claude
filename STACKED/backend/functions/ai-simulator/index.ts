import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

// AI Simulator Edge Function
// Handles OpenAI requests server-side — API key never exposed to client
serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return new Response(JSON.stringify({ error: "Unauthorized" }), {
        status: 401,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const supabaseClient = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_ANON_KEY") ?? "",
      { global: { headers: { Authorization: authHeader } } }
    );

    const { data: { user }, error: authError } = await supabaseClient.auth.getUser();
    if (authError || !user) {
      return new Response(JSON.stringify({ error: "Unauthorized" }), {
        status: 401,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // Check subscription for simulation limits
    const { data: profile } = await supabaseClient
      .from("profiles")
      .select("subscription_tier, total_simulations_run")
      .eq("id", user.id)
      .single();

    // Free tier: 3 simulations/day limit
    if (profile?.subscription_tier === "free") {
      const today = new Date().toISOString().split("T")[0];
      const { count } = await supabaseClient
        .from("simulations")
        .select("id", { count: "exact" })
        .eq("user_id", user.id)
        .gte("created_at", today);

      if ((count ?? 0) >= 3) {
        return new Response(JSON.stringify({
          error: "Daily simulation limit reached. Upgrade to Pro for unlimited simulations.",
          code: "LIMIT_REACHED"
        }), {
          status: 429,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        });
      }
    }

    const { prompt } = await req.json();

    if (!prompt || typeof prompt !== "string" || prompt.length > 500) {
      return new Response(JSON.stringify({ error: "Invalid prompt" }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    const openAIKey = Deno.env.get("OPENAI_API_KEY");
    if (!openAIKey) {
      throw new Error("OpenAI API key not configured");
    }

    const systemPrompt = `You are an elite financial AI for STACKED, a gamified financial literacy app.

Your job is to analyze "what if?" financial scenarios and return structured JSON with projections, insights, and motivational takeaways.

IMPORTANT RULES:
1. Always be encouraging and motivational
2. Use simple, Gen Z-friendly language
3. Include concrete numbers and projections
4. Always include the educational disclaimer
5. Suggest smarter alternatives
6. Make users feel empowered, not judged
7. NEVER give specific investment or legal advice — always say "this is educational"

Return a JSON object matching this exact structure:
{
  "headline": "Brief exciting headline with emoji",
  "summary": "2-3 sentence overview of the scenario",
  "projections": [
    {
      "id": "string",
      "label": "Time period",
      "value": number,
      "formatted": "$X,XXX",
      "timeframe": "string",
      "isPositive": boolean,
      "emoji": "relevant emoji"
    }
  ],
  "opportunityCost": {
    "description": "What you're potentially leaving on the table",
    "amount": number,
    "formatted": "$X,XXX",
    "emoji": "⏰",
    "comparison": "Relatable comparison"
  },
  "smarterAlternatives": [
    {
      "id": "string",
      "title": "Short title",
      "description": "Brief action",
      "potentialGain": "Quantified benefit",
      "emoji": "emoji"
    }
  ],
  "motivationalTakeaway": "Inspiring 1-2 sentence takeaway with emoji",
  "tags": ["relevant", "tags"],
  "timeframe": "Overall projection timeframe",
  "charts": [
    {
      "id": "string",
      "title": "Chart title",
      "type": "area",
      "dataPoints": [
        {"id": "string", "label": "X label", "value": number, "formattedValue": "string", "series": "Series name"}
      ],
      "yAxisLabel": "Value ($)",
      "xAxisLabel": "Timeline"
    }
  ]
}`;

    const response = await fetch("https://api.openai.com/v1/chat/completions", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${openAIKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: "gpt-4.1",
        messages: [
          { role: "system", content: systemPrompt },
          { role: "user", content: `Financial scenario: "${prompt}"\n\nAnalyze this and return the JSON structure.` }
        ],
        temperature: 0.7,
        max_tokens: 2000,
        response_format: { type: "json_object" }
      }),
    });

    if (!response.ok) {
      const errorData = await response.json();
      console.error("OpenAI error:", errorData);
      throw new Error(`OpenAI API error: ${response.status}`);
    }

    const openAIData = await response.json();
    const resultContent = openAIData.choices[0].message.content;
    const result = JSON.parse(resultContent);
    const tokensUsed = openAIData.usage?.total_tokens ?? 0;

    // Add disclaimer and ID
    const finalResult = {
      id: crypto.randomUUID(),
      query: prompt,
      disclaimer: "⚠️ This is educational content, not financial advice. Projections are illustrative estimates based on general assumptions. Consult a licensed financial advisor for personalized guidance.",
      ...result,
    };

    // Save to DB
    await supabaseClient.from("simulations").insert({
      user_id: user.id,
      prompt,
      result: finalResult,
      tokens_used: tokensUsed,
    });

    // Update stats
    await supabaseClient.rpc("award_xp", {
      p_user_id: user.id,
      p_xp: 50,
      p_money_iq_gain: 2,
    });

    return new Response(JSON.stringify(finalResult), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });

  } catch (error) {
    console.error("Edge function error:", error);
    return new Response(JSON.stringify({ error: "Internal server error" }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
