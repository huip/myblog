setting = require '../settings'
markdown = require('markdown').markdown
User = require '../models/user'
Post = require '../models/post'
module.exports = (app)->
  # render index page
  app.get '/',(req,res)->
    indexPage req,res,1
  app.get '/index',(req,res)->
    indexPage req,res,1
  # init index page
  app.get '/index/:page',(req,res)->
    indexPage req,res,req.params.page
  # render about page 
  app.get '/about',(req,res)->
    res.render 'about',
      title: 'about page'
      brand: setting.brand
      motto: setting.motto
      index: setting.nav.index
      about: setting.nav.about
      user: req.session.user 
      categories: setting.categories
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
    if postId.length isnt 24
      res.render '404'
      return false
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
    res.redirect "/login" if not req.session.user?
  # index page common
  indexPage = (req,res,page)->
    args =
      condition: ''
      page: parseInt page
      pageSize: 10
    Post.getTotal args,(err,total)->
      Post.getPosts args,(err,posts)->
        posts.forEach (post)->
          post.post = markdown.toHTML post.post
        res.render 'index',
          title: setting.title
          brand: setting.brand
          motto: setting.motto
          index: setting.nav.index
          about: setting.nav.about
          posts: posts
          page: args.page
          categories: setting.categories
          isFirstPage: (args.page - 1) == 0
          isLastPage: ((args.page - 1)*args.pageSize + posts.length) == total
          user: req.session.user 
