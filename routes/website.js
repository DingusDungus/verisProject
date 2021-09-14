/**
 * Route for bank.
 */
"use strict";

const express = require("express");
const router = express.Router();
const website = require("../src/website.js");
const bodyParser = require("body-parser");
const urlencodedParser = bodyParser.urlencoded({ extended: false });

router.get("/index", (req, res) => {
    let data = {
        title: "Welcome | The Website"
    };

    res.render("website/index", data);
});

router.get("/register", (req, res) => {
    let data = {
        title: "Register | The Website"
    };

    res.render("website/register", data);
});

router.get("/user/:username", async (req, res) => {
    if (req.session.name == req.params.username) {
        let data = {
            title: "User view | The Website"
        };

        res.render("website/user", data);
    }
    else {
        let data = {
            title: "Welcome | The Website"
        };

        req.session.name = " ";

        res.render("website/index", data)
    }
});

router.post("/index/login", urlencodedParser, async (req, res) => {
    let data = {
        title: "Welcome | The Website"
    };

    let result = await website.login(req.body.username, req.body.passwordUser);
    if (result.length > 0) {
        req.session.name = req.body.username;
        res.redirect(`/user/${req.body.username}`);
    }
    else {
        res.redirect("/index");
    }
});

router.post("/index/register", urlencodedParser, async (req, res) => {
    let registerSucces = await website.register(req.body.username, req.body.passwordUser, req.body.email);

    if (registerSucces == true) {
        let data = {
            title: "Welcome | The Website"
        };

        req.session.name = req.body.username;

        res.redirect(`/user/${req.body.username}`);
    }
    else
    {
        let data = {
            title: "Welcome | The Website"
        };

        res.redirect(`/register`);
    }
});

module.exports = router;
