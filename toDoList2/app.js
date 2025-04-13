const express = require('express')
const bodyParser = require('body-parser')
const path = require('path')
const app = express()
const db = require('./db')
const PORT = process.env.PORT || 3000
const collection = "todo"

app.use(express.json())
app.use(express.urlencoded({extended: true}))
app.set('view engine', 'ejs')

app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'))
})

app.put('/:id', (req, res) => {
    const todoID = req.params.id
    const userInput = req.body

    db.getDB().collection(collection).findOneAndUpdate({_id : db.getPrimaryKey(todoID)}, {$set : {todo : userInput.todo}}, {returnOriginal : false}, (err, result) => {
        if(err)
            console.log(err)
        else {
            result.value.todoUpdated = userInput.todo
            res.json(result)
        }
    })
})

app.get('/getTodos', (req, res) => {
    db.getDB().collection(collection).find({}).toArray((err, documents) => {
        if(err)
            console.error(err)
        else {
            console.log(documents)
            res.json(documents)
        }
    })
})

app.get('/getTodo/:id', (req, res) => {
    db.getDB().collection(collection).find({"_id" : db.getPrimaryKey(req.params.id)}).toArray((err, result) => {
        if (err) {
            console.log(err)
        } else {
            res.json(result)
        }
    })
})

app.post('/', (req, res) => {
    const userInput = req.body
    db.getDB().collection(collection).insertOne(userInput, (err, result) => {
        if(err)
            console.log(err)
        else
            res.json({result : result})
    })
})

app.delete('/:id', (req, res) => {
    const todoID = req.params.id
    db.getDB().collection(collection).findOneAndDelete({_id : db.getPrimaryKey(todoID)}, (err, result) => {
        if(err) {
            console.log(err)
        } else {
            res.json(result)
        }
    })
})

db.connect((err) => {
    if(err) {
        console.log('Unable to connect to DB: ', err)
        process.exit(1);
    }
    else {
        app.listen(PORT, () => {
            console.log("Connected to DB, ", `App listening on port ${PORT}`)
        })
    }
})