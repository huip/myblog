crypto = require 'crypto'
setting = require "../settings"
User = require "../models/user"
module.exports = (app)->
  app.post "/api/user",(req,res)->
    status = {}
    md5 = crypto.createHash('md5')
    newUser = new User {
      username: req.body.username
      email: req.body.email
      password: md5.update(req.body.password).digest('base64')
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
        else
          status.status_code = 201
          req.session.user = newUser
          res.send status
