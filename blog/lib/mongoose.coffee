setting = require '../settings'
mongoose = module.exports = require 'mongoose'
mongoose.connect 'mongodb://'+setting.db.host+':'+setting.db.port+'/'+setting.db.name
mongoose.connected = true
mongoose.connection.on 'open',->
  mongoose.connected = true
