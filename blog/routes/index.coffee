setting = require '../settings'
user = require '../models/user'
module.exports = (app)->
  # render index page
  app.get '/',(req,res)->
    res.render 'index',
      title: setting.title
      brand: setting.brand
      motto: setting.motto
      index: setting.nav.index
      about: setting.nav.about
      user: req.session.user 
  app.get '/index',(req,res)->
    res.render 'index',
      title: setting.title
      brand: setting.brand
      motto: setting.motto
      index: setting.nav.index
      about: setting.nav.about
      user: req.session.user 
  # render about page 
  app.get '/about',(req,res)->
    res.render 'about',
      title: 'about page'
      brand: setting.brand
      motto: setting.motto
      index: setting.nav.index
      about: setting.nav.about
      user: req.session.user 
  # render login page
  app.get '/login',(req,res)->
    res.render 'login',
      title: 'login page'
      brand: setting.brand
      motto: setting.motto
      index: setting.nav.index
      about: setting.nav.about
      user: req.session.user 
  # render register page
  app.get '/register',(req,res)->
    res.render 'register',
      title: 'register page'
      brand: setting.brand
      motto: setting.motto
      index: setting.nav.index
      about: setting.nav.about
      user: req.session.user
  # check user is login
  checkLogin = (req,res)->
    res.redirect "/login" if !req.session.user
