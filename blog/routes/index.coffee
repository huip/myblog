setting = require '../settings'
markdown = require('markdown').markdown
User = require '../models/user'
Post = require '../models/post'
module.exports = (app)->
  # render index page
  app.get '/',(req,res)->
    args =
      condition: ''
      page: 1
      pageSize: 10
    Post.getPosts args,(err,posts)->
      console.log posts
      posts.forEach (post)->
        post.post = markdown.toHTML post.post
      res.render 'index',
        title: setting.title
        brand: setting.brand
        motto: setting.motto
        index: setting.nav.index
        about: setting.nav.about
        posts:posts
        user: req.session.user 
  app.get '/index',(req,res)->
    args =
      condition: ''
      page: 1
      pageSize: 10
    Post.getPosts args,(err,posts)->
      posts.forEach (post)->
        post.post = markdown.toHTML post.post
      res.render 'index',
        title: setting.title
        brand: setting.brand
        motto: setting.motto
        index: setting.nav.index
        about: setting.nav.about
        posts:posts
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
  # list post by id
  app.get '/p/:id',(req,res)->
    postId = req.params.id
    Post.getPostById postId,(err,post)->
       console.log err if err
       post.post = markdown.toHTML post.post
       res.render 'page',
        title: 'register page'
        brand: setting.brand
        motto: setting.motto
        index: setting.nav.index
        about: setting.nav.about
        user: req.session.user
        post: post
  # check user is login
  checkLogin = (req,res)->
    res.redirect "/login" if !req.session.user
