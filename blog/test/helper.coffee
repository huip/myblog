ParseDate = require '../middlewares/helper'
time = new Date()
console.log ParseDate(time).getSeconds('|')
