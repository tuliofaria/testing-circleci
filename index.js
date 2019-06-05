const VERSION = 2
const port = process.env.PORT || 3000

const express = require('express')
const app = express()

app.get('/', (req, res) => {
    res.send({
        out: 'running version ' + VERSION
    })
})

app.listen(port, err => {
    if(err){
        console.log(err)
    }else{
        console.log('running server on port', port)
    }
})
