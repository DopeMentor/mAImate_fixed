const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");

admin.initializeApp();
const db = admin.firestore();

const OPENAI_API_KEY = functions.config().openai.key;
const OPENAI_API_URL = "https://api.openai.com/v1/chat/completions";

exports.nlp = functions.https.onRequest(async (req, res) => {
  const { text } = req.body;

  if (!text) {
    return res.status(400).json({ error: "Missing input text" });
  }

  try {
    const systemPrompt = `
Analysoi seuraava lause ja palauta vain tämä JSON-rakenne (ei mitään muuta ympärille):

{
  "reply": "Vastaus käyttäjälle",
  "intent": "intent-nimi",
  "entities": {
    "dates": ["päivä"],
    "times": ["kellonaika"],
    "locations": ["paikka"],
    "people": ["nimi"]
  }
}
`.trim();

    const response = await axios.post(
      OPENAI_API_URL,
      {
        model: "gpt-4o",
        messages: [
          { role: "system", content: systemPrompt },
          { role: "user", content: text },
        ],
        temperature: 0.3,
      },
      {
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${OPENAI_API_KEY}`,
        },
      }
    );

    console.log("✅ FULL OPENAI RESPONSE:");
    console.dir(response.data, { depth: null });

    const choice = response.data.choices?.[0]?.message?.content;
    if (!choice) {
      return res.status(500).json({ error: "OpenAI ei palauttanut sisältöä" });
    }

    const jsonMatch = choice.match(/{[\s\S]*}/);
    if (!jsonMatch) {
      return res.status(500).json({ error: "OpenAI ei palauttanut JSONia" });
    }

    const parsed = JSON.parse(jsonMatch[0]);
    const { reply, intent, entities } = parsed;

    await db.collection("memories").add({
      text,
      reply,
      intent,
      entities,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    if (intent === "meeting" && entities?.dates?.length > 0) {
      const dateStr = entities.dates[0];
      const timeStr = entities.times?.[0] || "12:00";
      const parsedDate = parseDateTime(dateStr, timeStr);

      if (parsedDate) {
        await db.collection("events").add({
          title: text,
          date: admin.firestore.Timestamp.fromDate(parsedDate),
          createdByAI: true,
          sourceText: text,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });
      }
    }

    return res.status(200).json({ reply, intent, entities });
  } catch (error) {
    console.error("🔥 OPENAI ERROR:", error?.response?.data || error.message);
    return res.status(500).json({ error: "OpenAI-virhe" });
  }
});

function parseDateTime(dateStr, timeStr) {
  try {
    const parts = dateStr.split(/[.\-/]/);
    const timeParts = timeStr.split(":");
    const day = parseInt(parts[0]);
    const month = parseInt(parts[1]) - 1;
    const year = parts[2] ? parseInt(parts[2]) : new Date().getFullYear();
    const hour = parseInt(timeParts[0]);
    const minute = parseInt(timeParts[1]);
    return new Date(year, month, day, hour, minute);
  } catch (err) {
    console.error("❌ DATE PARSE ERROR:", err.message);
    return null;
  }
}

