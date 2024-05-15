const express = require('express');
const app = express();
const port = 3000;

// Middleware to parse JSON request bodies
app.use(express.json());

// Initialize the car door status
let carDoorStatus = 'locked';

// Endpoint to set the car door status
app.post('/set-door-status', (req, res) => {
    const { status } = req.body;

    if (status !== 'locked' && status !== 'unlocked') {
        return res.status(400).send('Invalid status. Please use "locked" or "unlocked".');
    }

    carDoorStatus = status;
    res.send(`${status}`);
});

// Endpoint to check the current door status
app.get('/door-status', (req, res) => {
    res.send(`${carDoorStatus}`);
});

// Start the server
app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});
