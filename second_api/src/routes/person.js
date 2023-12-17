const express = require("express");
const router = express.Router();

router.get("/person", (req, res) => {
  if (req.query.name) {
    res.status(200).send(`You have requested for a person, ${req.query.name}`);
  } else {
    res.status(200).send("You have requested for a person");
  }
});

router.get("/person/:name", (req, res) => {
  res.status(200).send(`You have requested for a person ${req.params.name}`);
});

router.get("/error", (req, res) => {
  throw new Error(`This is a Forced Error`);
});

module.exports = router;
