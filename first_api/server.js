require('dotenv').config()
const express = require('express');
const app = express();
const chalk = require('chalk');
const mongoose = require('mongoose');

const log = console.log;

mongoose.connect(process.env.DATABASE_URL, { useNewUrlParser: true, useUnifiedTopology: true })
const db = mongoose.connection

db.on('error', (error) => log(chalk.red(error)))
db.once('open', () => log('Connected to Database'))

app.use(express.json())

const subscribersRouter = require('./routes/subscribers')
app.use('/subscribers', subscribersRouter)


app.listen(3000, () => log(chalk.blue('Server Started!')))