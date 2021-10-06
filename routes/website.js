/**
 * Route for bank.
 */
"use strict";

const express = require("express");
const router = express.Router();
const website = require("../src/website.js");
const bodyParser = require("body-parser");
const { render } = require("ejs");
const urlencodedParser = bodyParser.urlencoded({ extended: false });

router.get("/index", (req, res) => {
    let data = {
        title: "Welcome | The Website"
    };

    res.render("website/index", data);
});

router.get("/login/students", (req, res) => {
    let data = {
        title: "Welcome | The Website"
    };

    res.render("website/login-students", data);
});

router.get("/login/admins", (req, res) => {
    let data = {
        title: "Welcome | The Website"
    };

    res.render("website/login-admins", data);
});

router.get("/register", (req, res) => {
    let data = {
        title: "Register | The Website",
        failed: false
    };

    res.render("website/register", data);
});

router.get("/students/:username", async (req, res) => {
    if (req.session.name == req.params.username) {
        let data = {
            title: "User view | The Website",
            name: req.session.name,
            result1: []
        };

        data.result1 = await website.showPickupReady(req.session.id);

        res.render("website/student-home", data);
    }
    else {
        let data = {
            title: "Welcome | The Website"
        };

        req.session.name = " ";

        res.render("website/index", data)
    }
});

router.get("/admins/:username", async (req, res) => {
    if (req.session.name == req.params.username) {
        let data = {
            title: "User view | The Website",
            results: [],
            name: req.session.name
        };
        data.results = await website.showEquipment();

        res.render("website/admin-home", data);
    }
    else {
        let data = {
            title: "Welcome | The Website"
        };

        req.session.name = " ";

        res.render("website/index", data)
    }
});

router.get("/admin-features/add", async (req, res) => {
    let data = {
        title: "Add equipment | Veris",
        name: req.session.name
    }

   res.render("website/equipment-add.ejs", data); 
});

router.get("/admin-features/remove/:id", async (req, res) => {
    website.removeEquipment(req.params.id);

    res.redirect(`/admins/${req.session.name}`);
});

router.get("/admin-features/modify/:id", async (req, res) => {
    let data = {
        title: "Modify equipment | Veris",
        results: [],
        name: req.session.name
    };
    data.results = await website.getEquipmentInfo(req.params.id);
    data.results = data.results[0];
    
    res.render(`website/equipment-modify.ejs`, data);
});

router.get("/student-features/book", async (req, res) => {
        let data = {
            title: "Book | Veris",
            results: [],
            name: req.session.name
        };
        data.results = await website.showEquipment();

        res.render("website/equipment-book.ejs", data)
});

router.get("/student-features/book/:id", async (req, res) => {
    let data = {
        title: "Book | Veris",
        results: [],
        name: req.session.name,
        disabledDate: []
    };
    data.results = await website.getEquipmentInfo(req.params.id);
    data.results = data.results[0];
    let disabledDates = await website.showBookedDates();
    
    for (let i = 0;i < disabledDates.length;i++)
    {
        data.disabledDate.push(disabledDates[i].booked.toLocaleDateString('fr-CA'));
    }
    data.disabledDate.push('2021-10-10');

    console.log(data.disabledDate);


    res.render("website/equipment-book-followed.ejs", data)
});

router.get("/student-features/pick-up/:es_id", async (req, res) => {
    let data = {
        title: "Book | Veris",
        results: [],
        name: req.session.name
    };

    await website.pick_up(req.params.es_id);

    res.redirect(`/students/${req.session.name}`);
});

router.post("/index/login-students", urlencodedParser, async (req, res) => {
    let result = await website.login(req.body.username, req.body.passwordUser);
    let accInfo = await website.getAccountInfo(req.body.username);
    console.log(accInfo);

    if (result.length > 0) {
        req.session.name = req.body.username;
        req.session.id = accInfo[0].id;

        res.redirect(`/students/${req.body.username}`);
    }
    else {
        res.redirect("/login/students");
    }
});

router.post("/admin-features/overview-search", urlencodedParser, async (req, res) => {
    let data = {
        title: "Overview | Veris",
        results: [],
        name: req.session.name
    };
    data.results = await website.searchEquipment(req.body.search);

    res.render("website/admin-home", data);
});

router.post("/index/login-admins", urlencodedParser, async (req, res) => {
    let result = await website.adminLogin(req.body.username, req.body.passwordUser);
    

    if (result.length > 0) {
        req.session.name = req.body.username;
        res.redirect(`/admins/${req.body.username}`);
    }
    else {
        res.redirect("/login/admins");
    }
});

router.post("/index/register", urlencodedParser, async (req, res) => {
    let registerSucces = await website.register(req.body.username, req.body.passwordUser, req.body.email);

    if (registerSucces == true) {
        let accInfo = await website.getAccountInfo(req.body.username);
        req.session.name = req.body.username;
        req.session.id = accInfo[0].id;

        res.redirect(`/students/${req.body.username}`);
    }
    else
    {
        let data = {
            title: "Register | Veris",
            failed: true
        };
    
        res.render("website/register", data);
    }
});

router.post("/add-equipment", urlencodedParser, async (req, res) => {
    await website.addEquipment(req.body.name, req.body.description, req.body.quantity);

    res.redirect(`/admins/${req.session.name}`);
});

router.post("/modify-equipment", urlencodedParser, async (req, res) => {
    await website.modifyEquipment(req.body.id, req.body.name, req.body.description);

    res.redirect(`/admins/${req.session.name}`);
});

router.post("/student-booked", urlencodedParser, async (req, res) => {
    console.log(req.body.date);
    await website.bookEquipment(req.session.id, req.body.id, req.body.quantity, req.body.date);


    res.redirect(`/students/${req.session.name}`);
});

module.exports = router;
