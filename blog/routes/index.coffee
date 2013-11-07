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
  app.get "/admin",(req,res)->
    res.render "admin",
      title: setting.admin.title
      brand: setting.admin.brand
      list: setting.admin.list
      post: setting.admin.post
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
      name: req.session.user.username
    }
    Post.get arg,(err,posts,total)->
      console.log err if err
      res.render "list",
        title: setting.admin.title
        brand: setting.admin.brand
        list: setting.admin.list
        post: setting.admin.post
        posts: posts
        total: total
