setting = require "../settings"
Post = require "../models/post"
module.exports = (app)->
  app.get "/",(req,res)->
    res.render "index",
      title: setting.title
      brand: setting.brand
      motto: setting.motto
      index: setting.nav.index
      about: setting.nav.about
      login: setting.nav.login
      register: setting.nav.register

 # article info
  app.get "/p/:id",(req,res)->
    Post.getOne req.params.id,(err,docs)->
     console.log err if err
     res.json docs

 # admin page 
  app.get "/admin",(req,res)->
    arg = {
      page: 1
      limit: 10
    }
    Post.get arg,(err,posts,total)->
      console.log err if err
      res.render "admin_list",
        title: setting.admin.title
        brand: setting.admin.brand
        list: setting.admin.list
        post: setting.admin.post
        posts: posts
  app.get "/admin/post",(req,res)->
    res.render "post",
      title: setting.admin.title
      brand: setting.admin.brand
      list: setting.admin.list
      post: setting.admin.post
  # get post list  
  app.get "/admin/list/:id",(req,res)->
    arg = {
      page: req.params.id
      limit: 10
    }
    Post.get arg,(err,posts,total)->
      console.log err if err
      res.render "admin_list",
        title: setting.admin.title
        brand: setting.admin.brand
        list: setting.admin.list
        post: setting.admin.post
        posts: posts
        total: total
