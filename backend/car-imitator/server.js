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

// Endpoint to set the car door status
app.post("/set-door-status", async (req, res) => {
  const { status } = req.body;

  if (status !== "locked" && status !== "unlocked") {
    return res
      .status(400)
      .send('Invalid status. Please use "locked" or "unlocked".');
  }

  // Introduce a fake delay between 0.2 and 1 second
  await delay(200, 1000);

  // Simulate a 15% chance of returning an error
  if (shouldError(0.15)) {
    return res.status(500).send("Simulated server error");
  }

  // Add one more delay before actually updating the status of the car
  delay(1000, 6000).then(() => {
    carDoorStatus = status;
  });

  res.send(`${status}`);
});

// Endpoint to check the current door status
app.get("/door-status", async (req, res) => {
  // Introduce a fake delay between 0.1 and 2 seconds
  await delay(100, 2000);

  // Simulate a 15% chance of returning an error
  if (shouldError(0.15)) {
    return res.status(500).send("Simulated server error");
  }

  res.send(`${carDoorStatus}`);
});

// Start the server
app.listen(port, () => {
  console.log(`car-imitator running at http://localhost:${port}`);
});
