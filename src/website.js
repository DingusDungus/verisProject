"use strict";
const mysql = require("promise-mysql");
const config = require("../config/website.json");
let db;

(async function () {
    db = await mysql.createConnection(config);

    process.on("exit", () => {
        db.end();
    });
})();

let website = {
    login: async function (username, password) {
        let sql = `CALL login_check_students(?, ?);`;
        let res;

        res = await db.query(sql, [username, password]);
        return res[0];

    },
    register: async function (username, password, email) {
        let success = false;
        let res;
        let sql = `CALL registerCheck_students(?);`;
        res = await db.query(sql, [username]);
        if (res[0].length == 0) {
            sql = `CALL register_students(?, ?, ?);`;


            await db.query(sql, [username, password, email]);
            success = true;
        }
        return success;
    },
    getID: async function (username, password) {
        let sql = 'CALL getID_students(?, ?);';
        let res;

        res = await db.query(sql, [username, password]);
        return res[0];
    },
    adminRegister: async function (username, email, password) {
        let sql = 'CALL register_admins(?, ?, ?);';

        await db.query(sql, [username, password, email]);
    },
    adminLogin: async function (username, password) {
        let sql = `CALL login_check_admins(?, ?);`;
        let res;

        res = await db.query(sql, [username, password]);
        return res[0];
    },
    addEquipment: async function(name, description, quantity) {
        let sql = `CALL equipment_add(?, ?);`;
        for (let i = 0;i < quantity;i++)
        {
            await db.query(sql, [name, description]);
        }
    },
    addEquipmentTest: async function()
    {
        let sql = `CALL equipment_add_test();`;
        let result =  await db.query(sql);
        return result[0];
    },
    showEquipment: async function()
    {
        let sql = `CALL equipment_show();`;
        let result = await db.query(sql);
        return result[0];
    },
    removeEquipment: async function(id)
    {
        let sql = `CALL equipment_remove(?);`;
        await db.query(sql, [id]);
    },
    searchEquipment: async function(search)
    {
        let sql = `CALL equipment_search(?);`;
        let result = await db.query(sql, [search]);

        return result[0];
    },
    modifyEquipment: async function(id, name, description)
    {
        let sql = `CALL equipment_modify(?, ?, ?);`;
        let result = await db.query(sql, [id, name, description]);

        return result[0];
    },
    getEquipmentInfo: async function(id)
    {
        let sql = `CALL equipment_info_get(?);`;
        let result = await db.query(sql, [id]);

        return result[0];
    },
    showBookedDates: async function(id)
    {
        let sql = `CALL show_booked_dates(?);`;
        let result = await db.query(sql, [id]);

        return result;
    },
    bookEquipment: async function(s_id, e_id, date)
    {
        let sql = `CALL equipment_book(?,?,?)`;
        let splitDate = date.split('/');
        splitDate[2].split(" ");
        let year = splitDate[2].split(' ');
        console.info(year);
        let newDate = new Date(year[0], splitDate[0] - 1, splitDate[1]);
        console.log(newDate.toDateString());

        console.log("Student id:" + s_id);
        console.log("Equipment id:" + e_id);

        await db.query(sql, [s_id, e_id, newDate]);

    },
    getAccountInfo: async function(username)
    {
        let sql = `CALL get_account_info(?)`;
        let result = await db.query(sql, [username]);

        return result[0];
    },
    showPickupReady: async function(id)
    {
        let sql = `CALL showPickupReady(?);`;
        let result = await db.query(sql, [id]);

        return result[0];
    },
    pick_up: async function(id)
    {
        let sql = `CALL pick_up(?);`;
        await db.query(sql, [id]);
    },
    showReturnableAndOverdue: async function(id)
    {
        let sql = `CALL showReturnableAndOverdue(?);`;  
        let result = await db.query(sql, [id]);

        return result;
    },
    returnEquipment: async function(id, e_id)
    {
        let sql = `CALL e_return(?,?);`;

        await db.query(sql, [id, e_id]);
    },
    reserve: async function(a_id, e_id, date)
    {
        let sql = `CALL equipment_reserve(?,?,?);`;

        await db.query(sql, [a_id, e_id, date]);
    }
};

module.exports = website;
