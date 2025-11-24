import { log, logsAPI } from "./logger.js";
import express from "express";

const app = express();
const port = 3001;

// Middleware to parse JSON request bodies
app.use(express.json());

// Initialize the car door status
let carDoorStatus = "locked";

// Helper function to add a delay
function delay(min, max) {
  const randomDelay = Math.random() * (max - min) + min;
  return new Promise((resolve) => setTimeout(resolve, randomDelay));
}

// Helper function to randomly decide if an error should occur
function shouldError(probability) {
  return Math.random() < probability;
}

// Helper function to handle error simulation based on header
function handleErrorSimulation(errorType) {
  log("Evaluating error simulation", logsAPI.SeverityNumber.DEBUG, {
    errorType: errorType,
  });

  switch (errorType) {
    case "400":
      log("Error simulation: Triggering 400 Bad Request", logsAPI.SeverityNumber.WARN, {
        errorType: errorType,
        decision: "error",
        statusCode: 400,
      });
      return { shouldError: true, statusCode: 400, message: "Simulated 400 Bad Request error" };
    case "500":
      log("Error simulation: Triggering 500 Internal Server Error", logsAPI.SeverityNumber.WARN, {
        errorType: errorType,
        decision: "error",
        statusCode: 500,
      });
      return { shouldError: true, statusCode: 500, message: "Simulated 500 Internal Server Error" };
    case "none":
      log("Error simulation: No error (success path)", logsAPI.SeverityNumber.DEBUG, {
        errorType: errorType,
        decision: "success",
      });
      return { shouldError: false };
    case "random":
    default:
      // 15% chance of error
      if (shouldError(0.15)) {
        log("Error simulation: Random triggered error (15% chance)", logsAPI.SeverityNumber.WARN, {
          errorType: errorType,
          decision: "error",
          statusCode: 500,
        });
        return { shouldError: true, statusCode: 500, message: "Random simulated server error" };
      }
      log("Error simulation: Random chose success path", logsAPI.SeverityNumber.DEBUG, {
        errorType: errorType,
        decision: "success",
      });
      return { shouldError: false };
  }
}

// Endpoint to set the car door status
app.post("/set-door-status", async (req, res) => {
  const { status } = req.body;
  const errorType = req.headers["x-debug-error-type"] || "random";
  
  log("requesting /set-door-status", logsAPI.SeverityNumber.INFO, {
    errorType: errorType,
  });

  if (status !== "locked" && status !== "unlocked") {
    const message =
      'Invalid status. Please use "locked" or "unlocked". Returning 400';
    log(message, logsAPI.SeverityNumber.ERROR);
    return res.status(400).send(message);
  }

  // Introduce a fake delay between 0.2 and 1 second
  await delay(200, 1000);

  // Handle error simulation based on header
  const errorResult = handleErrorSimulation(errorType);
  if (errorResult.shouldError) {
    log("Returning error response for /set-door-status", logsAPI.SeverityNumber.ERROR, {
      errorType: errorType,
      statusCode: errorResult.statusCode,
      message: errorResult.message,
    });
    return res.status(errorResult.statusCode).send(errorResult.message);
  }

  log("Successfully processing /set-door-status request", logsAPI.SeverityNumber.INFO, {
    status: status,
    errorType: errorType,
    currentDoorStatus: carDoorStatus,
  });

  // Add one more delay before actually updating the status of the car
  delay(1000, 30000).then(() => {
    log(
      "Updating car door status after random delay",
      logsAPI.SeverityNumber.INFO,
      { 
        previousStatus: carDoorStatus,
        newStatus: status,
      }
    );

    carDoorStatus = status;
  });

  log("Sending success response for /set-door-status", logsAPI.SeverityNumber.INFO, {
    responseStatus: status,
  });

  res.send(`${status}`);
});

// Endpoint to check the current door status
app.get("/door-status", async (req, res) => {
  const errorType = req.headers["x-debug-error-type"] || "random";
  
  log("requesting /door-status", logsAPI.SeverityNumber.INFO, {
    errorType: errorType,
  });

  // Introduce a fake delay between 0.1 and 2 seconds
  await delay(100, 2000);

  // Handle error simulation based on header
  const errorResult = handleErrorSimulation(errorType);
  if (errorResult.shouldError) {
    log("Returning error response for /door-status", logsAPI.SeverityNumber.ERROR, {
      errorType: errorType,
      statusCode: errorResult.statusCode,
      message: errorResult.message,
    });
    return res.status(errorResult.statusCode).send(errorResult.message);
  }

  log("Successfully processing /door-status request", logsAPI.SeverityNumber.INFO, {
    currentDoorStatus: carDoorStatus,
    errorType: errorType,
  });

  res.send(`${carDoorStatus}`);
});

// Start the server
app.listen(port, () => {
  log(
    `car-imitator running at http://localhost:${port}`,
    logsAPI.SeverityNumber.DEBUG
  );
});
