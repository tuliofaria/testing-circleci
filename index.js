const VERSION = 2
const port = process.env.PORT || 3000

const express = require('express')
const app = express()

const dbSettings = {
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    pass: process.env.DB_PASS || 'devpleno',
    db: process.env.DB_NAME || 'devshop'
}

const knex = require('knex')({
    client: 'mysql2',
    connection: {
      host : dbSettings.host,
      user : dbSettings.user,
      password : dbSettings.pass,
      database : dbSettings.db
    }
  });

app.get('/db', async(req, res) => {
    const date = await knex.raw('select now() as now')
    res.send({
        dateFromDB: date[0][0].now
    })
})

app.get('/', (req, res) => {
    res.send(`
        <h1>Running version: ${VERSION}</h1>
        <p><a href="/db">Check DB Connection</a></p>
    `)
})

app.listen(port, err => {
    if(err){
        console.log(err)
    }else{
        console.log('running server on port', port)
    }
})
