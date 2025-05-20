const functions = require("firebase-functions/v2/https");
const { onRequest, HttpsError } = functions;
const cors = require("cors")({ origin: true });

exports.priceEstimate = onRequest((req, res) => {
  cors(req, res, async () => {
    try {
      const { location, size, rooms, balcony } = req.body;

      if (!location || !size) {
        throw new HttpsError("invalid-argument", "location and size are required");
      }

      const pricePerSqm = await getPricePerSqmFromApi(location, rooms, balcony);

      if (!pricePerSqm) {
        throw new HttpsError("not-found", "No price data found for location");
      }

      let adjustmentFactor = 1.0;
      if (balcony) adjustmentFactor += 0.03;

      const estimatedPrice = Math.round(size * pricePerSqm * adjustmentFactor);

      res.status(200).json({
        location,
        size,
        rooms,
        balcony,
        pricePerSqm: pricePerSqm.toFixed(2),
        estimatedPrice,
        adjustmentFactor,
        explanation: `Price based on ${location} avg €/m² and ${balcony ? "+3% balcony" : "no balcony"}`
      });
    } catch (error) {
      console.error("Price estimate error:", error);
      res.status(500).json({ error: error.message || "Internal server error" });
    }
  });
});

// 🔧 Kovakoodattu hintadata – voit korvata myöhemmin API-haulla
async function getPricePerSqmFromApi(location, rooms, balcony) {
  const staticData = {
    "kaleva": 3278.90,
    "tammela": 3450.00,
    "keskusta": 4800.00,
    "pispala": 3100.00
  };

  const key = location.toLowerCase().trim();
  return staticData[key] || null;
}

