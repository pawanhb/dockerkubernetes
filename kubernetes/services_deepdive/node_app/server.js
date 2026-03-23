const express = require('express');
const app = express();
const port = 3000;
const os = require('os');
const hostname = os.hostname();

app.get('/', (req, res) =>{
res.send('Hello from Node App');
});

app.get('/api',(req, res)=>{
  const format = req.query.format;
  if( format === 'json' ){
    res.send({
      port,	  
      hostname
    });
  } else{
    res.send(`port= ${port}, hostname= ${hostname}`);
  }
});

app.listen(port, ()=>{
console.log(`Server running on port: ${port}`);
});

