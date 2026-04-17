const express = require('express');
const port = 3000;

const app = express();

app.get('/', (req, res) =>{
    res.send("Hello from node app running in docker!!");
});

app.listen(port, () =>{
    console.log(`application listening on port ${port}`);
});
