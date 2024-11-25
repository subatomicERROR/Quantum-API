// pages/api/quantum.js

const { spawn } = require('child_process');

export default function handler(req, res) {
  if (req.method === 'GET') {
    const x = req.query.x || 1;  // Get parameter `x` from query
    
    // Spawn the Python process
    const python = spawn('python3', ['quantum-api/quantum_api.py', x]);

    python.stdout.on('data', (data) => {
      // Send the result from Python to the client
      res.status(200).json({ result: data.toString() });
    });

    python.stderr.on('data', (data) => {
      res.status(500).json({ error: data.toString() });
    });

    python.on('close', (code) => {
      if (code !== 0) {
        res.status(500).json({ message: 'Python script failed' });
      }
    });
  } else {
    res.status(405).json({ message: 'Method Not Allowed' });
  }
}
