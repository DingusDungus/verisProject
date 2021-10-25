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

router.get("/index", async (req, res) => {
    let data = {
        title: "Welcome | The Website"
    };

    res.render("website/index", data);
});

router.get("/login/students", (req, res) => {
    let data = {
        title: "Welcome | The Website",
        failedLogin: false
    };

    res.render("website/login-students", data);
});

router.get("/login/admins", (req, res) => {
    let data = {
        title: "Welcome | The Website",
        failedLogin: false
    };

    res.render("website/login-admins", data);
});

router.get("/register", (req, res) => {
    let data = {
        title: "Register | The Website",
        failed: false,
        emailValid: true
    };

    res.render("website/register", data);
});

router.get("/students/:username", async (req, res) => {
    console.log(req.session.name);
    if (req.session.name == req.params.username) {
        let data = {
            title: "User view | The Website",
            name: req.session.name,
            result1: [],
            result2: []
        };

        data.result1 = await website.showPickupReady(req.session.id);

        data.result2 = await website.showReturnableAndOverdue(req.session.id);

        res.render("website/student-home", data);
    }
    else {
        let data = {
            title: "Welcome | The Website"
        };

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


        res.render("website/index", data)
    }
});

router.get("/admin-features/add", async (req, res) => {
    let isAdmin = await website.isAdmin(req.session.id, req.session.name);

    if (isAdmin.length > 0) {
        let data = {
            title: "Add equipment | Veris",
            name: req.session.name
        }

        res.render("website/equipment-add.ejs", data); 
    } else {
        let data = {
            title: "Welcome | The Website"
        };


        res.render("website/index", data)
    }
});

router.post("/admin-features/remove", urlencodedParser, async (req, res) => {
    website.removeEquipment(req.body.id);

    res.redirect(`/admins/${req.session.name}`);
});

router.get("/admin-features/modify/:id", async (req, res) => {
    let isAdmin = await website.isAdmin(req.session.id, req.session.name);

    if (isAdmin.length > 0) {
    let data = {
        title: "Modify equipment | Veris",
        results: [],
        name: req.session.name
    };
    data.results = await website.getEquipmentInfo(req.params.id);
    data.results = data.results[0];
    
    res.render(`website/equipment-modify.ejs`, data);
} else {
    let data = {
        title: "Welcome | The Website"
    };


    res.render("website/index", data)
}
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
    let disabledDates = await website.showBookedDates(req.params.id);
    console.log(disabledDates);
    for (let i = 0;i < disabledDates[0].length;i++)
    {
        data.disabledDate.push(disabledDates[0][i].booked.toLocaleDateString('fr-CA'));
    }

    for (let i = 0;i < disabledDates[1].length;i++)
    {
        data.disabledDate.push(disabledDates[1][i].reserved.toLocaleDateString('fr-CA'));
    }

    console.log(data.disabledDate);


    res.render("website/equipment-book-followed.ejs", data)
});

router.get("/admin-features/reserve/:id", async (req, res) => {
    let isAdmin = await website.isAdmin(req.session.id, req.session.name);

    if (isAdmin.length > 0) {
    let data = {
        title: "Book | Veris",
        results: [],
        name: req.session.name,
        disabledDate: [],
        failed: false
    };
    data.results = await website.getEquipmentInfo(req.params.id);
    data.results = data.results[0];
    let disabledDates = await website.showBookedDates(req.params.id);
    
    for (let i = 0;i < disabledDates[0].length;i++)
    {
        data.disabledDate.push(disabledDates[0][i].booked.toLocaleDateString('fr-CA'));
    }

    for (let i = 0;i < disabledDates[1].length;i++)
    {
        data.disabledDate.push(disabledDates[1][i].reserved.toLocaleDateString('fr-CA'));
    }

    console.log(data.disabledDate);


    res.render("website/equipment-reserve-followed.ejs", data);
} else {
    let data = {
        title: "Welcome | The Website"
    };


    res.render("website/index", data)
}
});

router.get("/admin-features/show-history", async (req, res) => {
    let isAdmin = await website.isAdmin(req.session.id, req.session.name);

    if (isAdmin.length > 0) {
    let data = {
        title: "Book | Veris",
        results: [],
        name: req.session.name
    };

    data.results = await website.showEquipmentHistory();

    res.render("website/equipment-history.ejs", data);
} else {
    let data = {
        title: "Welcome | The Website"
    };


    res.render("website/index", data)
}
});

router.get("/student-features/pick-up/:es_id", async (req, res) => {
    await website.pick_up(req.params.es_id);

    res.redirect(`/students/${req.session.name}`);
});

router.get("/student-features/return/:id/:e_id", async (req, res) => {
    await website.returnEquipment(req.params.id, req.params.e_id);

    res.redirect(`/students/${req.session.name}`);
});

router.get("/admin-features/manage-accounts", async (req, res) => {
    let isAdmin = await website.isAdmin(req.session.id, req.session.name);

    if (isAdmin.length > 0) {
    let data = {
        title: "Book | Veris",
        results: [],
        name: req.session.name
    };

    data.results = await website.showAccounts();

    res.render("website/account-manage.ejs", data);
} else {
    let data = {
        title: "Welcome | The Website"
    };


    res.render("website/index", data)
}
});

router.get("/log-out", async (req, res) => {
    req.session.id = " ";
    req.session.name = " ";

    res.redirect(`/index`, );
});

router.get("/admin-features/track-status/:id", async (req, res) => {
    let isAdmin = await website.isAdmin(req.session.id, req.session.name);

    if (isAdmin.length > 0) {
    let data = {
        title: "Status | Veris",
        results: [],
        name: req.session.name
    };

    data.results = await website.show_booking(req.params.id, req.session.id);
    console.log(data.results);

    res.render("website/track-status.ejs", data);
} else {
    let data = {
        title: "Welcome | The Website"
    };


    res.render("website/index", data)
}
});

router.post("/admin-features/delete-student", urlencodedParser, async (req, res) => {
    await website.deleteStudent(req.body.id);

    res.redirect(`/admin-features/manage-accounts`);
});    

router.post("/index/login-students", urlencodedParser, async (req, res) => {
    let result = await website.login(req.body.username, req.body.passwordUser);
    let accInfo = await website.getAccountInfo(req.body.username);

    if (result.length > 0) {
        req.session.name = req.body.username;
        req.session.id = accInfo[0][0].id;

        res.redirect(`/students/${req.body.username}`);
    }
    else {
        let data = {
            title: "Welcome | Veris",
            name: req.session.name,
            failedLogin: true
        };
        res.render("website/login-students", data);
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

router.post("/student-features/book-search", urlencodedParser, async (req, res) => {
    let data = {
        title: "Book | Veris",
        results: [],
        name: req.session.name
    };
    data.results = await website.searchEquipment(req.body.search);

    res.render("website/equipment-book.ejs", data);
});

router.post("/index/login-admins", urlencodedParser, async (req, res) => {
    let result = await website.adminLogin(req.body.username, req.body.passwordUser);
    let accInfo = await website.getAccountInfo(req.body.username);

    if (result.length > 0) {
        req.session.name = req.body.username;
        req.session.id = accInfo[1][0].id;


        res.redirect(`/admins/${req.body.username}`);
    }
    else {
        let data = {
            title: "Welcome | Veris",
            name: req.session.name,
            failedLogin: true
        };
        res.render("website/login-admins", data);
    }
});

router.post("/index/register", urlencodedParser, async (req, res) => {
    let emailValid = await website.emailValid(req.body.email);
    let usernameTaken = await website.usernameTaken(req.body.username);

    if (!usernameTaken && emailValid) {
        await website.register(req.body.username, req.body.passwordUser, req.body.email);

        let accInfo = await website.getAccountInfo(req.body.username);
        req.session.name = req.body.username;
        req.session.id = accInfo[0][0].id;

        res.redirect(`/students/${req.body.username}`);
    }
    else
    {
        let data = {
            title: "Register | Veris",
            failed: false,
            emailValid: false
        };
        if (emailValid)
        {
            data.emailValid = true;
        }
        if (usernameTaken)
        {
            data.failed = true;
        }
    
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
    await website.bookEquipment(req.session.id, req.body.id, req.body.date);


    res.redirect(`/students/${req.session.name}`);
});

router.post("/admin-reserved", urlencodedParser, async (req, res) => {
    console.log("DateString: " + req.body.date1);
    console.log("DateString: " + req.body.date2);


    let splitDate = req.body.date1.split('/');
    splitDate[2].split(" ");
    let year = splitDate[2].split(' ');
    let newDate1 = new Date(year[0], splitDate[0] - 1, splitDate[1]);
    let splitDate1 = req.body.date2.split('/');
    splitDate1[2].split(" ");
    let year1 = splitDate1[2].split(' ');
    let newDate2 = new Date(year1[0], splitDate1[0] - 1, splitDate1[1]);
    let diss = await website.showBookedDates(req.body.id);
    console.log(diss);
    let match = 0;

    for (let loopDate = newDate1;loopDate < newDate2;loopDate.setDate(loopDate.getDate() + 1))
    {
        for (let i = 0;i < diss[0].length;i++)
        {
           if (loopDate.toLocaleDateString() == diss[0][i].booked.toLocaleDateString())
           {
            match++;
           }
        }

        for (let i = 0;i < diss[1].length;i++)
        {
            
           if (loopDate.toLocaleDateString() == diss[1][i].reserved.toLocaleDateString())
           {
            match++;
           }
        }
    }

    let validReserve = true;

    if (match > 0)
    {
        validReserve = false;
    } 
    
    
    if (validReserve) {
        newDate1 = new Date(year[0], splitDate[0] - 1, splitDate[1]);
        newDate2 = new Date(year1[0], splitDate1[0] - 1, splitDate1[1]);
        
        console.log("Date: " + newDate1.toLocaleDateString());
        console.log("Date: " + newDate2.toLocaleDateString());

        for (let loopDate = newDate1;loopDate <= newDate2;loopDate.setDate(loopDate.getDate() + 1))
        {
            website.reserve(req.session.id, req.body.id, loopDate);
        }
        res.redirect(`/admins/${req.session.name}`);
    }
    else
    {
        let data = {
            title: "Book | Veris",
            results: [],
            name: req.session.name,
            disabledDate: [],
            failed: true
        };
        data.results = await website.getEquipmentInfo(req.body.id);
        data.results = data.results[0];
        let disabledDates = await website.showBookedDates(req.body.id);

        console.log(disabledDates[0]);
        console.log(newDate1.toLocaleDateString('fr-CA'));
        
        for (let i = 0;i < disabledDates[0].length;i++)
        {
            data.disabledDate.push(disabledDates[0][i].booked.toLocaleDateString('fr-CA'));
        }
    
        for (let i = 0;i < disabledDates[1].length;i++)
        {
            data.disabledDate.push(disabledDates[1][i].reserved.toLocaleDateString('fr-CA'));
        }
    
        console.log(data.disabledDate);
    
        res.render("website/equipment-reserve-followed.ejs", data)
    }
});

router.post("/admin-history-search", urlencodedParser, async (req, res) => {
    let data = {
        title: "Equipment history | Veris",
        results: [],
        name: req.session.name
    };

    data.results = await website.showLogsSearch(req.body.search);


    res.render("website/equipment-history.ejs", data);
});

router.post("/admin-account-search", urlencodedParser, async (req, res) => {
    let data = {
        title: "Account management | Veris",
        results: [],
        name: req.session.name
    };

    data.results = await website.showAccountsSearch(req.body.search);


    res.render("website/account-manage.ejs", data);
});

module.exports = router;
