// 📁 functions/ai_core.js

const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const { pipeline } = require('node:stream/promises');
const { HfInference } = require('@huggingface/inference');

const app = express();
app.use(cors({ origin: true }));
app.use(bodyParser.json());

// 🔑 REPLACE THIS WITH YOUR ACTUAL HUGGINGFACE KEY
const hf = new HfInference("YOUR_HUGGINGFACE_API_KEY");

app.post("/custom-ai", async (req, res) => {
  try {
    const { message } = req.body;

    if (!message || typeof message !== "string") {
      return res.status(400).json({ reply: "Väärä pyyntö" });
    }

    const result = await hf.textGeneration({
      model: "mistralai/Mistral-7B-Instruct-v0.2",
      inputs: message,
      parameters: {
        max_new_tokens: 200,
        temperature: 0.6,
        do_sample: true,
      },
    });

    const reply = result.generated_text || "(ei vastausta)";

    return res.status(200).json({ reply });
  } catch (err) {
    console.error("AI virhe:", err);
    return res.status(500).json({ reply: "Palvelinvirhe tekoälyssä" });
  }
});

module.exports = app;

