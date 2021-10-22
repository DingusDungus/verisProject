"use strict";

const readline = require("readline");
const readlineSync = require("readline-sync");
const showMenu = require("./src/menuUI.js");
const website = require("./src/website.js");

let res;
let res1;

function exitProgram(code) {
    code = code || 0;

    console.log(`\nExiting with exit status: ${code}...`);
    process.exit(code);
}

(async function main() {
    const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout
    });

        rl.setPrompt("Super-user: ");
        rl.prompt();

        rl.on("close", exitProgram);
        rl.on("line", async (input) => {
            input = input.trim();
            let lineArray = input.split(' ');



            switch (lineArray[0]) {
                case "exit":
                case "quit":
                    exitProgram();
                    break;
                case "menu":
                case "help":
                    showMenu();
                    break;
                case "register":
                    await website.adminRegister(lineArray[1], lineArray[2], lineArray[3]);
                    break;
            }

            rl.prompt();
        });
}());