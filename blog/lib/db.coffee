setting = require "../settings"
mongodb = require "mongodb"
Db = mongodb.Db
Server = mongodb.Server
module.exports = new Db setting.db.name,new Server setting.db.host,setting.db.port,{}


