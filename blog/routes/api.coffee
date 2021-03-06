crypto = require 'crypto'
setting = require '../settings'
User = require '../models/user'
Post = require '../models/post'
status = {}
module.exports = (app) ->
 
 # user register api
  app.post '/api/u/register',(req,res) ->
    md5 = crypto.createHash('md5')
    newUser =
      name: req.body.username
      email: req.body.email
      password: md5.update(req.body.password).digest('base64')
   
   # confirm user is register
    User.get newUser,(err,user) ->
      if user?
        status.errorCode = 101
        res.json status
        return false
      # if not register do register
      User.save newUser,(err,info)->
        console.log info
        if err
          status.errorCode = 102
          res.json status
        else
          status.errorCode = 201
          req.session.user = info
          res.json status
 
 app.post '/api/u/login',(req,res) ->
    md5 = crypto.createHash('md5')
    userInfo =
      email: req.body.email
      password: md5.update(req.body.password).digest('base64')

    User.get userInfo, (err,user) ->
      if not user?
        # 103 means user is not exit
        status.errorCode = 103
      else if userInfo.password isnt user.password
        # 104 means user password is error
        status.errorCode = 104
      else
        # login success
        req.session.user = user
        status.errorCode = 202
      res.json status
  
  # add post
  app.post '/api/p/add',(req,res) ->
    checkLogin req,res
    args = req.body

    Post.add args,req.session.user.name,(err,post) ->
      status.errorCode = 203 if not err?
      res.json status
  
  app.post '/api/p/update/:id',(req,res)->
    checkLogin req,res
    args = req.body
    
    Post.modify args,req.session.user.name,(err,update) ->
      status.errorCode = 204
      res.json status

  # delte post by id 
  app.get '/api/p/remove/:id',(req,res) ->
    checkLogin req,res
   
   Post.remove req.params.id,(err,remove) ->
      res.redirect '/admin'

  app.get '/archive',(req,res) ->
   
   Post.getArchive (err,time) ->
      console.log time
  
  # check user is login
  checkLogin = (req,res) ->
    res.redirect '/login' if not req.session.user?
