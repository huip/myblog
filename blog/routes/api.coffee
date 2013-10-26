setting = require "../settings"
User = require "../models/user"
module.exports = (app)->
  app.post "/api/user",(req,res)->
    status = {}
    newUser = new User {
      username: req.body.username
      email: req.body.email
      password: req.body.password
    }
    User.get newUser.email,(err,user)->
      err = "user is already exists." if user
      status.status_code = 101
      if err
        res.send status
      newUser.save (err)->
        if err
          status.status_code = 103
          res.send status 
