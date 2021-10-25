# VerisProject

## Dependencies
- nodejs
- Node modules in directory /node_modules


## How to use install
Go into /sql and run `sudo mariadb < setup.sql`then `sudo mariadb < ddl.sql`

## Super user
### How to use
There's cli client for the super-user, the standard password is `password` but can be changed by the super-user.

To start cli client you write `nodejs cli.js` into terminal

## Web app
### How to use
To start web server you write `nodejs index.ejs` into terminal

To access it you go into browser and write `http://localhost:1337/index`

