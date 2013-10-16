setting = require "../settings"
mongodb = require "../models/db"
module.exports = (app)->
  app.get "/api/test",(req,res)->
    res.send "test"
