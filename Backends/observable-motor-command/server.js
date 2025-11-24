import { log, logsAPI } from "./logger.js";
import express from "express";
import dotenv from "dotenv";

dotenv.config();

const app = express();
const port = 3000;

// Middleware to parse JSON request bodies
app.use(express.json());

// Endpoint to set the car door status
app.post("/set-door-status", async (req, res) => {
  const { status } = req.body;
  const errorType = req.headers["x-debug-error-type"] || "random";
  
  log("requesting /set-door-status", logsAPI.SeverityNumber.INFO, {
    errorType: errorType,
  });
  const hostname = process.env.HOSTNAME;

  if (status !== "locked" && status !== "unlocked") {
    const message =
      'Invalid status. Please use "locked" or "unlocked". Returning 400';
    log(message, logsAPI.SeverityNumber.ERROR);
    return res.status(400).send(message);
  }

  try {
    log(
      "Forwarding /set-door-status request to car-imitator",
      logsAPI.SeverityNumber.INFO,
      { 
        errorType: errorType,
        targetService: "car-imitator",
        status: status,
      }
    );
    
    // Forward the error type header to car-imitator
    const headers = {
      "Content-Type": "application/json",
    };
    if (errorType) {
      headers["X-Debug-Error-Type"] = errorType;
      log("Including X-Debug-Error-Type header in downstream request", logsAPI.SeverityNumber.DEBUG, {
        header: "X-Debug-Error-Type",
        value: errorType,
      });
    }
    
    const response = await fetch(`http://${hostname}:3001/set-door-status`, {
      method: "POST",
      headers: headers,
      body: JSON.stringify({ status }),
    });

    log("Received response from car-imitator", logsAPI.SeverityNumber.INFO, {
      statusCode: response.status,
      statusText: response.statusText,
      isOk: response.ok,
    });

    // Check if the response status indicates an error
    if (!response.ok) {
      // Extract error message from the response
      const errorText = await response.text();
      log("car-imitator returned error response", logsAPI.SeverityNumber.ERROR, {
        statusCode: response.status,
        errorText: errorText,
        errorType: errorType,
      });
      throw new Error(`HTTP Error: ${response.status} - ${errorText}`);
    }

    const data = await response.text();
    log("Successfully completed /set-door-status request", logsAPI.SeverityNumber.INFO, {
      responseData: data,
      errorType: errorType,
    });
    res.send(`${data}`);
  } catch (error) {
    const message = `Error in /set-door-status: ${error.message}`;
    log(message, logsAPI.SeverityNumber.ERROR, {
      errorMessage: error.message,
      errorType: errorType,
      endpoint: "/set-door-status",
    });
    res.status(500).send(message);
  }
});

// Endpoint to check the current door status
app.get("/door-status", async (req, res) => {
  const hostname = process.env.HOSTNAME;
  const errorType = req.headers["x-debug-error-type"] || "random";

  log(
    "Forwarding /door-status request to car-imitator",
    logsAPI.SeverityNumber.INFO,
    { 
      errorType: errorType,
      targetService: "car-imitator",
    }
  );
  try {
    // Forward the error type header to car-imitator
    const headers = {};
    if (errorType) {
      headers["X-Debug-Error-Type"] = errorType;
      log("Including X-Debug-Error-Type header in downstream request", logsAPI.SeverityNumber.DEBUG, {
        header: "X-Debug-Error-Type",
        value: errorType,
      });
    }
    
    const response = await fetch(`http://${hostname}:3001/door-status`, {
      headers: headers,
    });

    log("Received response from car-imitator", logsAPI.SeverityNumber.INFO, {
      statusCode: response.status,
      statusText: response.statusText,
      isOk: response.ok,
    });

    // Check if the response status indicates an error
    if (!response.ok) {
      // Extract error message from the response
      const errorText = await response.text();
      log("car-imitator returned error response", logsAPI.SeverityNumber.ERROR, {
        statusCode: response.status,
        errorText: errorText,
        errorType: errorType,
      });
      throw new Error(`HTTP Error: ${response.status} - ${errorText}`);
    }

    const data = await response.text();
    log("Successfully completed /door-status request", logsAPI.SeverityNumber.INFO, {
      doorStatus: data,
      errorType: errorType,
    });
    res.send({ status: data });
  } catch (error) {
    const message = `Error in /door-status: ${error.message}`;
    log(message, logsAPI.SeverityNumber.ERROR, {
      errorMessage: error.message,
      errorType: errorType,
      endpoint: "/door-status",
    });
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
