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
  # add article
  app.post "/api/p/add",(req,res)->
    isLogin req,res
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
  # delete article
  app.get "/api/p/remove/:id",(req,res)->
    isLogin req,res
    Post.remove req.params.id,(err,info)->
      console.log err if err
      res.redirect "/admin" 
  # update article
  app.post "/api/p/update/:id",(req,res)->
    isLogin req,res
    args = 
      id: req.params.id
      name: req.session.user.username
      title: req.body.title
      tags: req.body.tags
      post: req.body.post
      
    Post.update args,(err,info)->
      console.log err if err
      status.status_code = 204
      res.json status
    

  # get one article info 
  app.get "/api/p/get/:id",(req,res)->
    Post.getOne req.params.id,"html",(err,docs)->
     console.log err if err
     res.json docs

  app.get "/api/p/list/:id",(req,res)->
    arg =
      page: req.params.id
      limit: 10
    Post.get arg,(err,posts,total)->
      console.log err if err
      post =
        posts:posts
        total:total
      res.json post
  # get article by tag name
  app.get "/api/p/tag/list/:tag",(req,res)->
    Post.getArticleByTagName req.params.tag,(err,docs)->
      result = {}
      console.log err if err
      result.docs = docs
      result.tag = req.params.tag
      res.json result
  # get tags 
  app.get "/api/wigets/tags",(req,res)->
    Post.getTags (err,tags)->
      console.log err if err
      res.json tags
  # get rencent articles title
  app.get "/api/wigets/recent/:id",(req,res)->
    arg = 
      page:1
      limit:req.params.id
    Post.get arg,(err,posts,total)->
      console.log err if err
      res.json posts
  isLogin = (req,res)->
    res.redirect "/login" if !req.session.user
   
