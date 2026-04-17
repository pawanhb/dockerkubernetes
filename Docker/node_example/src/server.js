const express = require('express');
const port = 3000;

const app = express();


app.get('/', (req,res) =>{

  res.send('Hello from simple node webserver running inside docker');

});


app.listen(port, ()=>{
  console.log(`Application listening on port ${port}`);
});
