import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

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

    const { message, history, sessionId } = await req.json();

    if (!message || typeof message !== "string" || message.length > 1000) {
      return new Response(JSON.stringify({ error: "Invalid message" }), {
        status: 400,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      });
    }

    // Get user profile for personalization
    const { data: profile } = await supabaseClient
      .from("profiles")
      .select("username, money_iq, level, financial_goals, interests, experience_level, subscription_tier")
      .eq("id", user.id)
      .single();

    const openAIKey = Deno.env.get("OPENAI_API_KEY");
    if (!openAIKey) throw new Error("OpenAI API key not configured");

    const systemPrompt = `You are the STACKED Money Coach — a brilliant, motivating, and practical AI financial coach.

USER PROFILE:
- Name: ${profile?.username ?? "User"}
- Money IQ: ${profile?.money_iq ?? 500}/1000
- Level: ${profile?.level ?? 1}
- Experience: ${profile?.experience_level ?? "beginner"}
- Goals: ${(profile?.financial_goals as string[])?.join(", ") ?? "building wealth"}
- Interests: ${(profile?.interests as string[])?.join(", ") ?? "general finance"}

YOUR PERSONALITY:
- Motivating and energetic (like a great personal trainer, but for money)
- Practical and actionable — always give concrete next steps
- Concise — keep responses under 200 words unless deep explanation is needed
- Gen Z friendly — conversational, not corporate
- Slightly witty but never dismissive
- Emotionally intelligent — acknowledge feelings before advice
- Smart but approachable — no jargon without explanation

YOUR RULES:
1. ALWAYS add a disclaimer when giving specific investment scenarios: "⚠️ Educational only, not financial advice"
2. NEVER tell users to buy specific stocks, crypto, or individual securities
3. DO recommend broad concepts: index funds, diversification, emergency funds, etc.
4. ALWAYS end with a concrete, actionable next step
5. Use emojis naturally but not excessively
6. If user seems discouraged, start with empathy before advice

FOCUS AREAS (based on user interests):
${(profile?.interests as string[])?.join(", ") ?? "all areas of personal finance"}`;

    // Build message history (max last 8 for context)
    const recentHistory = Array.isArray(history) ? history.slice(-8) : [];
    const messages = [
      { role: "system", content: systemPrompt },
      ...recentHistory.map((m: { role: string; content: string }) => ({
        role: m.role as "user" | "assistant",
        content: m.content,
      })),
      { role: "user", content: message },
    ];

    const response = await fetch("https://api.openai.com/v1/chat/completions", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${openAIKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: "gpt-4.1",
        messages,
        temperature: 0.8,
        max_tokens: 500,
        presence_penalty: 0.1,
        frequency_penalty: 0.1,
      }),
    });

    if (!response.ok) {
      throw new Error(`OpenAI API error: ${response.status}`);
    }

    const openAIData = await response.json();
    const reply = openAIData.choices[0].message.content;

    // Update or create coach session
    if (sessionId) {
      const newMessages = [
        ...recentHistory,
        { id: crypto.randomUUID(), role: "user", content: message, timestamp: new Date().toISOString() },
        { id: crypto.randomUUID(), role: "assistant", content: reply, timestamp: new Date().toISOString() },
      ];

      await supabaseClient
        .from("coach_sessions")
        .upsert({
          id: sessionId,
          user_id: user.id,
          messages: newMessages,
          updated_at: new Date().toISOString(),
        });
    }

    return new Response(JSON.stringify({ reply }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });

  } catch (error) {
    console.error("Coach edge function error:", error);
    return new Response(JSON.stringify({ error: "Coach temporarily unavailable. Please try again." }), {
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }
});
