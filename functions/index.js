const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");

admin.initializeApp();
const db = admin.firestore();

// Konfiguraatiot
const CONFIG = {
  USE_AI: true, // Vaihda falseksi jos haluat käyttää vain mock-vastauksia
  AI_API_KEY: process.env.HUGGINGFACE_API_KEY || "YOUR_API_KEY",
  AI_ENDPOINT: "https://api-inference.huggingface.co/models/microsoft/DialoGPT-medium",
  AI_TIMEOUT: 5000, // 5 sekuntia
  CORS_ENABLED: true
};

exports.nlp = functions.https.onRequest(async (req, res) => {
  // CORS-käsittely
  if (CONFIG.CORS_ENABLED) {
    res.set("Access-Control-Allow-Origin", "*");
    res.set("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
    res.set("Access-Control-Allow-Headers", "Content-Type");
    
    if (req.method === "OPTIONS") {
      return res.status(204).send("");
    }
  }

  try {
    const { message, userId, confirmed = false } = req.body;

    // Validointi
    if (!message) {
      return res.status(400).json({ 
        reply: "Virhe: Puuttuva viesti",
        needsConfirmation: false 
      });
    }

    // Intent-tunnistus
    const intent = detectIntent(message);
    const entities = extractEntities(message);

    // AI-vastaus (joko oikea API tai mock)
    let aiReply = CONFIG.USE_AI
      ? await callAI(message).catch(() => generateMockReply(message, intent))
      : generateMockReply(message, intent);

    // Tallenna muistiin
    if (userId) {
      await saveMemory(userId, message, intent, entities, aiReply);
    }

    // Kalenterilogiiikka
    if (intent === "calendar") {
      return handleCalendarIntent(
        res, confirmed, entities, userId, aiReply
      );
    }

    // Muistihaku
    if (intent === "memory_lookup" && userId) {
      return handleMemoryLookup(res, userId);
    }

    // Oletusvastaus
    return res.json({
      reply: aiReply,
      intent,
      entities,
      needsConfirmation: false
    });

  } catch (error) {
    console.error("Virhe NLP-funktiossa:", error);
    return res.status(500).json({
      reply: "Järjestelmävirhe. Yritä uudelleen.",
      needsConfirmation: false
    });
  }
});

// Apufunktiot
async function callAI(prompt) {
  try {
    const response = await axios.post(
      CONFIG.AI_ENDPOINT,
      { inputs: prompt },
      {
        headers: { Authorization: `Bearer ${CONFIG.AI_API_KEY}` },
        timeout: CONFIG.AI_TIMEOUT
      }
    );

    return response.data?.generated_text || 
           response.data?.[0]?.generated_text || 
           "En osaa vastata tähän vielä.";
  } catch (error) {
    console.error("AI-kutsun virhe:", error.message);
    throw error;
  }
}

function generateMockReply(message, intent) {
  const mockResponses = {
    calendar: {
      reply: `Haluatko varmasti lisätä tapahtuman '${message}'?`,
      needsConfirmation: true
    },
    memory: {
      reply: `Tallensin muistiin: "${message}"`,
      needsConfirmation: false
    },
    memory_lookup: {
      reply: "Näytän sinulle muistisi pian...",
      needsConfirmation: false
    },
    default: {
      reply: `Ymmärsin kysymyksesi: "${message}"`,
      needsConfirmation: false
    }
  };

  return mockResponses[intent] || mockResponses.default;
}

async function saveMemory(userId, message, intent, entities, reply) {
  const memoryData = {
    userId,
    message,
    intent,
    entities,
    reply,
    createdAt: admin.firestore.FieldValue.serverTimestamp()
  };

  return db.collection("memories").add(memoryData);
}

async function handleCalendarIntent(res, confirmed, entities, userId, aiReply) {
  if (confirmed) {
    const eventData = {
      userId,
      title: entities.title || "Tapahtuma",
      date: entities.date || "",
      time: entities.time || "",
      location: entities.location || "",
      createdAt: admin.firestore.FieldValue.serverTimestamp()
    };

    await db.collection("calendarEvents").add(eventData);

    return res.json({
      reply: "✅ Tapahtuma tallennettu kalenteriin!",
      needsConfirmation: false
    });
  }

  return res.json({
    reply: aiReply,
    needsConfirmation: true
  });
}

async function handleMemoryLookup(res, userId) {
  const snapshot = await db.collection("memories")
    .where("userId", "==", userId)
    .orderBy("createdAt", "desc")
    .limit(5)
    .get();

  const memories = snapshot.docs.map(doc => doc.data().message);
  const reply = memories.length > 0
    ? `Viimeisimmät muistisi:\n- ${memories.join("\n- ")}`
    : "Ei tallennettuja muistoja.";

  return res.json({ reply, needsConfirmation: false });
}

function detectIntent(text) {
  const lowered = text.toLowerCase();
  if (/muista|tallenna/.test(lowered)) return "memory";
  if (/näytä\s+muistot|muistot/.test(lowered)) return "memory_lookup";
  if (/kalenteri|tapahtuma|tapaaminen|klo|maanantai|tiistai|keskiviikko|torstai|perjantai/.test(lowered)) return "calendar";
  if (/hinta|arvio|kustannus/.test(lowered)) return "price_estimate";
  return "default";
}

function extractEntities(text) {
  return {
    date: text.match(/\d{1,2}\.\d{1,2}(?:\.\d{2,4})?|\d{1,2}\/\d{1,2}/)?.[0] || null,
    time: text.match(/\b\d{1,2}[:.]\d{2}\b|\bklo\s?\d{1,2}\b/i)?.[0].replace("klo", "").trim() || null,
    location: text.match(/(?:paikassa|osoitteessa|paikka|sijainti)\s+([^.,!?]+)/i)?.[1].trim() || null,
    title: text.match(/(?:lisää|luo)\s+([^.,!?]+)/i)?.[1].trim() || null
  };
}
