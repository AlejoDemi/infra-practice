const AWS = require('aws-sdk');
const { Client } = require('pg');

const s3 = new AWS.S3();

exports.handler = async (event) => {
  const { imageBase64 } = JSON.parse(event.body || '{}');

  const buffer = Buffer.from(imageBase64, 'base64');
  const key = `photos/${Date.now()}.jpg`;

  try {
    await s3.putObject({
      Bucket: process.env.BUCKET_NAME,
      Key: key,
      Body: buffer,
      ContentType: 'image/jpeg',
    }).promise();

    const client = new Client({
      host: process.env.DB_HOST,
      port: parseInt(process.env.DB_PORT),
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
    });

    await client.connect();

    await client.query(`
      CREATE TABLE IF NOT EXISTS photos (
        id SERIAL PRIMARY KEY,
        key TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    `);

    await client.query(`INSERT INTO photos (key) VALUES ($1)`, [key]);

    await client.end();

    return {
      statusCode: 200,
      body: JSON.stringify({ message: 'Imagen subida y guardada en RDS correctamente 🎉', key }),
    };
  } catch (err) {
    console.error(err);
    return {
      statusCode: 500,
      body: JSON.stringify({ message: 'Error en la Lambda', error: err.message }),
    };
  }
};
