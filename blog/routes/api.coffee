crypto = require "crypto"
setting = require "../settings"
User = require "../models/user"
Post = require "../models/post"
status = {}
module.exports = (app)->
  app.post "/api/u/register",(req,res)->
    md5 = crypto.createHash("md5")
    newUser = new User {
      username: req.body.username
      email: req.body.email
      password: md5.update(req.body.password).digest("base64")
    }
    User.get newUser.email,(err,user)->
      err = 101 if user
      status.status_code = err
      if err
        res.json status
        return false
      newUser.save (err)->
        if err
          status.status_code = 102
          res.json status
        else
          status.status_code = 201
          req.session.user = newUser
          res.json status
  app.post "/api/u/login",(req,res)->
    md5 = crypto.createHash("md5")
    email = req.body.email
    password = md5.update(req.body.password).digest("base64")
    User.get email,(err,user)->
      console.log user
      if user == null
        status.status_code = 103
        res.json status
        return false
      if user.password != password
        status.status_code = 104
        res.json status
        return false
      req.session.user = user
      status.status_code = 202
      res.json status
  app.post "/api/p/add",(req,res)->
    newPost = new Post {
      name: req.session.user.username 
      title: req.body.title
      tags: req.body.tags
      post: req.body.post
    }
    newPost.save (err)->
      if err
        status.status_code = 105
        res.json status
      else
        status.status_code = 203
        res.json status
  # article info 
  app.get "/api/p/get/:id",(req,res)->
    Post.getOne req.params.id,(err,docs)->
     console.log err if err
     res.json docs
  app.get "/api/p/list/:id",(req,res)->
    arg = {
      page: req.params.id
      limit: 10
    }
    Post.get arg,(err,posts,total)->
      console.log err if err
      res.json posts
