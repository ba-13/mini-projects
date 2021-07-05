# Simple Password Generator

To use on your system, you need to install the following dependencies:

```bash
sudo apt install nodejs
# You need npm for running these scripts.
npm i commander chalk clipboardy
```

To use this package globally,
You can run the following command while inside the directory:

```bash
sudo npm link
```

To get started, locally,

```bash
passgen -h
```

`package.json` already is modified to be supported globally on your system.  
To undo that, remove these lines from the json file:

```json
  "preferGlobal": true,
  "bin": "./index.js",
```

If you do prefer using globally, fyi, this line lets this package get added to `/usr/local/lib`:

```bash
#!/usr/bin/env node
```

Cheers!  
Credits: Traversery Media
