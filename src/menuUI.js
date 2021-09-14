"use strict";

function showMenu() {
    console.log(`
    Choose something from the menu:

    menu, help                          - Show this menu
    exit, quit                          - Exits program

    register <username> <email> <password>
`);
}

module.exports = showMenu;
