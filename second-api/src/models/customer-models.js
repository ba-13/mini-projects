const mongoose = require("mongoose");

mongoose.connect("mongodb://localhost:27017/mongo");
mongoose.connection
  .once("open", () => {
    console.log("Connected to MongoDB is successful.");
  })
  .on("error", (error) => {
    console.error("Connection.error", error);
  });
