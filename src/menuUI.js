"use strict";

function showMenu() {
    console.log(`
    Choose something from the menu:

    menu, help                              - Show this menu
    exit, quit                              - Exits program

    register <username> <email> <password>  - Registers a new admin to the database (warning duplicate names are not checked)
    changePassword <newPassword>            - Changes password for super-user
`);
}

module.exports = showMenu;
