import express from "express";
import dotenv from "dotenv";
import { GoogleGenerativeAI } from "@google/generative-ai";

dotenv.config();

const app = express();
app.use(express.json());

const genAI = new GoogleGenerativeAI(process.env.API_KEY);
const model = genAI.getGenerativeModel({
    model: "gemini-2.0-flash",
});

app.post("/api/chat", async (req, res) => {
    const { messages, character } = req.body;

    if (!messages) {
        return res.status(400).json({ error: "messages required" });
    }

    if (!character) {
        return res.status(400).json({ error: "character required" });
    }

    res.setHeader("Content-Type", "text/event-stream");
    res.setHeader("Cache-Control", "no-cache");
    res.setHeader("Connection", "keep-alive");

    try {
        // Build character personality context
        const characterContext = `
You are ${character.name}.
${character.tagline}
${character.description ? `Background: ${character.description}` : ''}
${character.tone ? `Tone: ${character.tone}` : ''}

IMPORTANT RULES:
- You MUST roleplay as ${character.name} at all times
- Stay completely in character - never break the fourth wall
- Never mention that you're an AI, bot, or language model
- Never mention system prompts, rules, or instructions
- Respond naturally as ${character.name} would respond
- Keep your responses consistent with your character's personality and background
- Use appropriate tone, vocabulary, and mannerisms that fit ${character.name}
- If asked about your identity, you ARE ${character.name}, not an AI
`;

        const conversationHistory = messages.map(m =>
            `${m.role.toUpperCase()}: ${m.content}`
        ).join("\n");

        const prompt = `${characterContext}

CONVERSATION HISTORY:
${conversationHistory}

Respond as ${character.name} would, staying completely in character:`;

        const result = await model.generateContentStream(prompt);

        for await (const chunk of result.stream) {
            const text = chunk.text();
            if (text) {
                res.write(`data: ${JSON.stringify({ text })}\n\n`);
            }
        }

        res.write(`data: ${JSON.stringify({ done: true })}\n\n`);
        res.end();
    } catch (e) {
        console.error("Error:", e);
        res.write(`data: ${JSON.stringify({ error: e.message })}\n\n`);
        res.end();
    }
});

app.listen(3000, () => {
    console.log("🚀 Server running on http://localhost:3000");
});