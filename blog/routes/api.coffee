setting = require "../settings"
User = require "../models/user"
module.exports = (app)->
  app.post "/api/user",(req,res)->
    newUser = new User {
      username: req.username
      email: req.email
      password: req.password
    }
    newUser.save (err)->
      if err
        console.log err

