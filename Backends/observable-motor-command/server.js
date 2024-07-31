import { log, logsAPI } from "./logger.js";
import express from "express";

const app = express();
const port = 3000;

// Middleware to parse JSON request bodies
app.use(express.json());

// Endpoint to set the car door status
app.post("/set-door-status", async (req, res) => {
  const { status } = req.body;
  log("requesting /set-door-status", logsAPI.SeverityNumber.INFO);

  if (status !== "locked" && status !== "unlocked") {
    const message =
      'Invalid status. Please use "locked" or "unlocked". Returning 400';
    log(message, logsAPI.SeverityNumber.ERROR);
    return res.status(400).send(message);
  }

  try {
    log(
      "requesting /set-door-status from car-imitator",
      logsAPI.SeverityNumber.INFO
    );
    const response = await fetch("http://localhost:3001/set-door-status", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ status }),
    });

    // Check if the response status indicates an error
    if (!response.ok) {
      // Extract error message from the response
      const errorText = await response.text();
      throw new Error(`HTTP Error: ${response.status} - ${errorText}`);
    }

    const data = await response.text();
    res.send(`${data}`);
  } catch (error) {
    const message = `Error in /set-door-status: ${error.message}`;
    log(message, logsAPI.SeverityNumber.ERROR);
    res.status(500).send(message);
  }
});

// Endpoint to check the current door status
app.get("/door-status", async (req, res) => {
  log(
    "requesting /door-status  from car-imitator",
    logsAPI.SeverityNumber.INFO
  );
  try {
    const response = await fetch("http://localhost:3001/door-status");

    // Check if the response status indicates an error
    if (!response.ok) {
      // Extract error message from the response
      const errorText = await response.text();
      throw new Error(`HTTP Error: ${response.status} - ${errorText}`);
    }

    const data = await response.text();
    res.send({ status: data });
  } catch (error) {
    const message = `Error in /door-status: ${error.message}`;
    log(message, logsAPI.SeverityNumber.ERROR);
    res.status(500).send(message);
  }
});

app.post("/failpost", async (req, res) => {
  const message = `Sending back 400 error for POST. Got body: ${req.body}`;
  log(message, logsAPI.SeverityNumber.ERROR);
  return res.status(400).json({ error: message });
});

app.post("/successpost", async (req, res) => {
  const message = `Sending back 200 success for POST. Got body: ${req.body}`;
  log(message, logsAPI.SeverityNumber.DEBUG);
  res.status(200).json({ message: message });
});

app.get("/failget", async (req, res) => {
  const message = `Sending back 400 error for GET.`;
  log(message, logsAPI.SeverityNumber.ERROR);
  return res.status(400).json({ error: message });
});

app.get("/successget", async (req, res) => {
  const message = `Sending back 200 success for GET.`;
  log(message, logsAPI.SeverityNumber.DEBUG);
  res.status(200).json({ message: message });
});

// Start the server
app.listen(port, () => {
  log(
    `OMC Server running at http://localhost:${port}`,
    logsAPI.SeverityNumber.DEBUG
  );
});
