const express = require('express');
const bodyParser = require('body-parser');
const admin = require('firebase-admin');
const WebSocket = require('ws');
const cors = require('cors');

const app = express();
const PORT = 3000;

// 🔐 Init Firebase Admin
const serviceAccount = require('./serviceAccountKey.json');
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

app.use(cors());
app.use(bodyParser.json());

// 🌐 WebSocket Server
const wss = new WebSocket.Server({ port: 8080 });
const clients = new Set();

wss.on('connection', (ws) => {
  console.log('🌐 WebSocket connected');
  clients.add(ws);

  ws.on('close', () => {
    clients.delete(ws);
  });
});

// 📩 Route: POST /send-alert
app.post('/send-alert', async (req, res) => {
  const data = req.body;
  console.log('📥 Received:', data);

  const broadcastData = {
    magnitude: data.magnitude,
    depth: data.depth,
    reaction: data.reaction,
    intensity: data.intensity,
    destructionNumber: data.destructionNumber,
    location: {
      _latitude: data.location.lat,
      _longitude: data.location.lng,
    },
    createDate: {
      _seconds: Math.floor(Date.now() / 1000), // current timestamp in seconds
    },
  };

  // ✅ FCM Push Notification
  try {
    const token = data.token || data.fcmToken;
    if (token) {
      await admin.messaging().send({
        token: token,
        notification: {
          title: '🌍 Earthquake Alert',
          body: `Magnitude ${data.magnitude} at lat: ${data.location.lat}, lng: ${data.location.lng}`,
        },
        data: {
          magnitude: String(data.magnitude),
          depth: String(data.depth),
          intensity: String(data.intensity),
          reaction: data.reaction,
          destructionNumber: String(data.destructionNumber),
          location: JSON.stringify(data.location),
        },
      });
      console.log('✅ FCM notification sent');
    }
  } catch (err) {
    console.error('❗ Error sending FCM:', err);
  }

  // ✅ Broadcast ผ่าน WebSocket
  for (const client of clients) {
    client.send(JSON.stringify(broadcastData));
  }
  console.log('✅ WebSocket message sent');

  res.status(200).send({ status: 'Success' });
});

// ▶️ Start Server
app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
});
