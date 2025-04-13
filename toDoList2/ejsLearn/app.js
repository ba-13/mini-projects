const express = require('express')
const bodyParser = require('body-parser')
const path = require('path')
const app = express()
const db = require('./db')

app.use(express.json())
app.use(express.urlencoded({extended: true}))
app.set('view engine', 'ejs')

app.get('/:userQuery', (req,res) => {
    res.render('index', {data: {userQuery: req.params.userQuery, username: req.params.userQuery, loggedIn: req.params.userQuery ? true:false},
                        searchResults : [`${req.params.userQuery} 1`, `${req.params.userQuery} 2`, `${req.params.userQuery} 3`, `${req.params.userQuery} 4`, `${req.params.userQuery} 5`]})
})

app.listen(3000, () => {
    console.log(`Server is listening at port 3000...`)
})