import express from "express";

const app = express();
const port = 3000;

// Middleware to parse JSON request bodies
app.use(express.json());

// Endpoint to set the car door status
app.post("/set-door-status", async (req, res) => {
  const { status } = req.body;

  if (status !== "locked" && status !== "unlocked") {
    return res
      .status(400)
      .send('Invalid status. Please use "locked" or "unlocked".');
  }

  try {
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
    res.status(500).send(`Error: ${error.message}`);
  }
});

// Endpoint to check the current door status
app.get("/door-status", async (req, res) => {
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
    res.status(500).send(`Error: ${error.message}`);
  }
});

// Start the server
app.listen(port, () => {
  console.log(`OMC Server running at http://localhost:${port}`);
});
