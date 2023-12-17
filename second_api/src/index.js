require("dotenv").config();
const chalk = require("chalk");
const fs = require("fs");
const path = require("path");
const express = require("express");
const app = express();
const port = process.env.PORT || 5000;

const rperson = require("./routes/person");

app.use((req, res, next) => {
  let data = `${new Date().getTime().toString()} => ${req.originalUrl}`;
  console.log(data);
  console.log(chalk.yellow(`Location of Script:`) + `${__dirname}`);
  console.log(
    chalk.yellow(`Current Working Directory of Node: `) + `${process.cwd()}`
  );
  // the path provided here is wrt to the directory where nodemon is executed.
  fs.appendFile(`log/test.log`, `${data}\n`, (err) => {
    if (err) {
      console.log(err);
    }
  });
  next();
});
app.use(rperson);
app.use(express.static("public"));

// 404 Handler, should be at the bottom.
app.use((req, res, next) => {
  res.status(404).send("404 Not Found");
});

// 500 Handler
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.sendFile(path.join(__dirname, "../public/505.html"));
});

app.listen(port, () => {
  console.log(`Server is listening on ${port}`);
});
