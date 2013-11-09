setting = require "../settings"
Post = require "../models/post"
module.exports = (app)->
  # index page
  app.get "/",(req,res)->
    res.render "index",
      title: setting.title
      brand: setting.brand
      motto: setting.motto
      index: setting.nav.index
      about: setting.nav.about
      user: req.session.user

  # login page
  app.get "/login",(req,res)->
    res.render "login",
      title: "title"
  # logout page
  app.get "/logout",(req,res)->
    req.session.user = null
    res.redirect "/"
  # register page
  app.get "/register",(req,res)->
    res.render "register",
      title: "register"

  # get one article info
  app.get "/p/:id",(req,res)->
    Post.getOne req.params.id,(err,docs)->
     console.log err if err
     res.json docs

 # admin page 
  app.get "/admin",(req,res)->
    isLogin req,res
    arg = {
      page: 1
      limit: 10
    }
    Post.get arg,(err,posts,total)->
      console.log err if err
      res.render "admin_list",
        title: setting.admin.title
        brand: setting.admin.brand
        index: setting.nav.index
        about: setting.nav.about
        user: req.session.user
        list: setting.admin.list
        post: setting.admin.post
        posts: posts

  # post article page
  app.get "/admin/post",(req,res)->
    isLogin req,res
    res.render "post",
      title: setting.admin.title
      index: setting.nav.index
      about: setting.nav.about
      brand: setting.admin.brand
      list: setting.admin.list
      post: setting.admin.post
      user: req.session.user

  # admin article list
  app.get "/admin/list/:id",(req,res)->
    isLogin req,res
    arg = {
      page: req.params.id
      limit: 10
    }
    Post.get arg,(err,posts,total)->
      console.log err if err
      res.render "admin_list",
        title: setting.admin.title
        brand: setting.admin.brand
        index: setting.nav.index
        about: setting.nav.about
        list: setting.admin.list
        post: setting.admin.post
        posts: posts
        total: total
        user: req.session.user

  # article edit page
  app.get "/admin/p/edit/:id",(req,res)->
    isLogin req,res
    Post.getOne req.params.id,"markdown",(err,docs)->
      console.log err if err
      res.render "edit",
        title: setting.admin.title
        brand: setting.admin.brand
        index: setting.nav.index
        about: setting.nav.about
        list: setting.admin.list
        post: setting.admin.post
        posts: docs
        user: req.session.user

  # check user is login
  isLogin = (req,res)->
    res.redirect "/login" if !req.session.user
