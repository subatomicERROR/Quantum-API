// pages/api/quantum.js

const { spawn } = require('child_process');

export default function handler(req, res) {
  if (req.method === 'POST') {
    // Extract 'data' from the request body and parse it as a number
    const { data } = req.body;
    
    if (data === undefined || data === null) {
      return res.status(400).json({ message: "Missing 'data' field in the request body" });
    }

    // Ensure 'data' is a valid number before passing it to the Python script
    const parsedData = parseFloat(data);
    if (isNaN(parsedData)) {
      return res.status(400).json({ message: "'data' must be a valid number" });
    }

    // Log the incoming data to check its value
    console.log('Received data:', parsedData);

    // Spawn the Python process and pass the parsed data as a command-line argument
    const python = spawn('python3', ['quantum-api/quantum_api.py', parsedData.toString()]);

    let outputData = ''; // Variable to collect Python script output

    // Set a timeout to kill the process if it takes too long
    const timeout = setTimeout(() => {
      python.kill('SIGKILL'); // Forcefully kill the Python process after a timeout
      res.status(500).json({ error: 'Request timed out' });
    }, 30000); // Set timeout to 30 seconds

    python.stdout.on('data', (output) => {
      outputData += output.toString(); // Collect the output from Python
    });

    python.stderr.on('data', (error) => {
      console.error('Python error:', error.toString()); // Log the error if Python script fails
      clearTimeout(timeout); // Clear timeout if an error happens
      res.status(500).json({ error: error.toString() });
    });

    python.on('close', (code) => {
      clearTimeout(timeout); // Clear timeout when process finishes

      if (code !== 0) {
        console.error('Python process failed with code', code); // Log Python process failure
        return res.status(500).json({ message: 'Python script failed' });
      }

      // Log and send back the Python output once the process ends
      console.log('Python output:', outputData);
      res.status(200).json({ result: outputData });
    });

  } else {
    res.status(405).json({ message: 'Method Not Allowed' });
  }
}
