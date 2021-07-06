# First REST API

This is my first REST API, which means nothing except that it `awaits` and is `async`.  
This is meant to POST new registrations, GET them, PATCH any, DELETE any, and GET one.  
Database used is `MongoDB`, and `mongoose` library provides a nice way to interact with mongod running on your local.

---

Dependencies:

```bash
sudo apt-get install nodejs
# This is for npm and node.
# You must have MongoDB installed on your machine.
```

To install MongoDB, you can refer [here](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/).

```bash
sudo systemctl status mongod
# If response is inactive, then run the following:
sudo systemctl start mongod
```

Node Dependencies:

- express
- mongoose
- dotenv --save-dev
- chalk
- nodemon --save-dev

`--save-dev` makes them development dependencies, that don't get installed in production.  
`dotenv` allows to pull env variables from .env file.  
`nodemon` allows to refresh the server without restarting it every time.  
`chalk` only because I like it.

Note: You can install all dependencies by `npm install` alone, all are saved in package.json already.  
Note: To use nodemon, put the following: `{ 'devStart': 'nodemon server.js' }` in scripts of `package.json`.

If you are using VSCode, Install the extension `REST Client` while developing, for extremely convienient requests and response interface.
