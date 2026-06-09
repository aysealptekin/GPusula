const admin = require("firebase-admin");
const {setGlobalOptions} = require("firebase-functions");
const {onCall, HttpsError} = require("firebase-functions/v2/https");
const {defineSecret} = require("firebase-functions/params");

admin.initializeApp();
setGlobalOptions({maxInstances: 10});

const geminiApiKey = defineSecret("GEMINI_API_KEY");

exports.askPusulaAi = onCall(
  {region: "us-central1", secrets: [geminiApiKey]},
  async (request) => {
    const uid = request.auth && request.auth.uid;
    if (!uid) {
      throw new HttpsError("unauthenticated", "Pusula AI icin giris yapmalisin.");
    }

    const question = String(request.data && request.data.question || "").trim();
    if (!question) {
      throw new HttpsError("invalid-argument", "Soru bos olamaz.");
    }

    const financeSummary = request.data && request.data.financeSummary || {};
    const userRef = admin.firestore().collection("users").doc(uid);
    const usageRef = userRef.collection("aiUsage").doc("pusula");

    const allowed = await admin.firestore().runTransaction(async (transaction) => {
      const usageSnap = await transaction.get(usageRef);
      const usedCount = usageSnap.exists ? Number(usageSnap.data().usedCount || 0) : 0;

      if (usedCount >= 1) {
        return false;
      }

      transaction.set(
        usageRef,
        {
          usedCount: usedCount + 1,
          freeLimit: 1,
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        },
        {merge: true},
      );
      return true;
    });

    if (!allowed) {
      return {
        answer: "Pusula AI hakkın doldu. Devam etmek için premium'a geçmelisin.",
        requiresPremium: true,
      };
    }

    const answer = await askGemini({
      apiKey: geminiApiKey.value(),
      question,
      financeSummary,
    });

    return {answer, requiresPremium: false};
  },
);

async function askGemini({apiKey, question, financeSummary}) {
  const endpoint =
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";

  const prompt = [
    "Sen Pusula AI'sın. Türkçe cevap ver.",
    "Bir finans uygulamasında kullanıcıya kısa, net ve yargılamayan öneriler veriyorsun.",
    "Cevabı 3-5 cümlede tut. Kesin yatırım tavsiyesi verme.",
    "Kullanıcının finans özeti:",
    JSON.stringify(financeSummary),
    `Kullanıcının sorusu: ${question}`,
  ].join("\n");

  const response = await fetch(`${endpoint}?key=${apiKey}`, {
    method: "POST",
    headers: {"Content-Type": "application/json"},
    body: JSON.stringify({
      contents: [{parts: [{text: prompt}]}],
      generationConfig: {
        temperature: 0.45,
        maxOutputTokens: 280,
      },
    }),
  });

  if (!response.ok) {
    const errorText = await response.text();
    throw new HttpsError(
      "internal",
      `Pusula AI yaniti alinamadi: ${errorText}`,
    );
  }

  const json = await response.json();
  const text = json.candidates &&
    json.candidates[0] &&
    json.candidates[0].content &&
    json.candidates[0].content.parts &&
    json.candidates[0].content.parts[0] &&
    json.candidates[0].content.parts[0].text;

  return text || "Şu an net bir cevap üretemedim. Birazdan tekrar dene.";
}
