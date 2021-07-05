#!/usr/bin/env node

const program = require('commander');
const chalk = require('chalk');
const clipboard = require('clipboardy');
const fs = require('fs');
const createPassword = require('./utils/createPassword.js');
const savePassword = require('./utils/savePassword.js');

const log = console.log;

program.version('1.0.0').description('Simple Password Generator');

/*
program.command('generate').action(()=>{
    console.log('Generated');
}).parse();
*/

program
    .option('-l, --length <number>', 'length of password', '8')
    .option('-s, --save', 'save password to passwords.txt')
    .option('-nn, --no-numbers', 'remove numbers')
    .option('-ns, --no-symbols', 'remove symbols')
    .option('-rp, --rm-passwd', 'remove all passwords in passwords.txt')
    .parse(); // --no-something, commander understands something to be true by default.

const { length, save, numbers, symbols, rmPasswd } = program.opts()

// Get generated password
const generatedPassword = createPassword(length, numbers, symbols)

// Save to file
save ? savePassword(generatedPassword) : '';

// Delete all passwords in file
rmPasswd ? fs.writeFile((__dirname, 'passwords.txt'), '', function(){console.log(chalk.red('Removed!'))}) : ''

// Copying to clipboard
clipboard.writeSync(generatedPassword);

// Output generated password
log(chalk.blue('Generated Password: ') + chalk.bold(generatedPassword));
log(chalk.yellow('Passsword copied to Clipboard!'))
