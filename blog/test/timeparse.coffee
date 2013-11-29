ParseDate = require '../middlewares/timeparse'
time = new Date()
console.log ParseDate(time).getSeconds()
