setting = require "../settings"
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
      
