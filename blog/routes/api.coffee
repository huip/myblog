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
    md5 = crypto.createHash("md5")
    userInfo =
      email: req.body.email
      password: md5.update(req.body.password).digest("base64")
    User.get userInfo,(err,user)->
      if not user?
        # 103 means user is not exit
        status.errorCode = 103
      else if userInfo.password isnt user.password
        # 104 means user password is error
        status.errorCode = 104
      else
        # login success
        status.errorCode = 202
      res.json status
   
        
