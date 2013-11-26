crypto = require "crypto"
setting = require "../settings"
User = require "../models/user"
status = {}
module.exports = (app)->
  # user register api
  app.post '/api/u/register',(req,res)->
    md5 = crypto.createHash("md5")
    newUser =
      name: req.body.username
      email: req.body.email
      password: md5.update(req.body.password).digest("base64")
    # confirm user is register
    User.get newUser,(err,user)->
      err  = '101' if user
      status.errorCode = err
      if err
        res.json status
        return false
      # if not register do register
      User.save newUser,(err,user)->
        if err
          status.errorCode = 102
          res.json status
        else
          status.errorCode = 201
          req.session.user = user
          res.json status
  app.post "/api/u/login",(req,res)->
        
