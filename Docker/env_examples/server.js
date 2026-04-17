const express = require('express');

const port = process.env.PORT;

const app = express();

app.get('/', (req, res) =>{
    res.send(`Hello from ${process.env.APP_NAME} running in docker!!`);
});

app.listen(port, () =>{
    console.log(`application listening on port ${port}`);
});
