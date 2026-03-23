const express = require('express');
const app = express();
const port = 3000;
const os = require('os');
const hostname = os.hostname();
var  count = 1;

app.get('/',(req, res)=>{
  res.send('Hello from Node app running in Kubernetes');
});

app.get('/api', (req, res)=>{
  const format = req.query.format; //https://localhost:3000/api?format=json
  if( format == 'json'){
    res.send({
      port,
      hostname
    });
  } else{
    res.send(`PORT: ${port} and HOSTNAME:${hostname}`);
  }
});

app.get('/ready', (req, res)=>{
  console.log('Executing ready');
  var req_success = count % 3 === 0;
  console.log(req_success);
  if ( req_success){
   count = 1;
   res.status(200).send('ok')
  } else {
  count = count + 1;
  res.status(503).send('Error');
 }
});

app.listen(port, ()=>{
  console.log(`Application listening on port ${port}`);
});
