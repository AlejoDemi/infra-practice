const AWS = require("aws-sdk");
const s3 = new AWS.S3();

exports.handler = async (event) => {
  console.log("📦 EVENT:", JSON.stringify(event));
  
  try {
    const body = typeof event.body === "string" ? JSON.parse(event.body) : event.body;

    if (!body || !body.imageBase64) {
      throw new Error("Falta imageBase64 en el body");
    }

    const image = Buffer.from(body.imageBase64, "base64");

    const bucket = process.env.BUCKET_NAME;
    if (!bucket) throw new Error("BUCKET_NAME no definido en environment");

    const key = `foto-${Date.now()}.jpg`;

    await s3.putObject({
      Bucket: bucket,
      Key: key,
      Body: image,
      ContentType: "image/jpeg",
    }).promise();

    return {
      statusCode: 200,
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ message: "Foto subida!", key }),
    };
  } catch (error) {
    console.error("💥 ERROR:", error.message);

    return {
      statusCode: 500,
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        error: error.message || "Error desconocido",
        stack: error.stack,
      }),
    };
  }
};

