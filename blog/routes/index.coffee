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
      widgets: renderWidgets()
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
        widgets: renderWidgets()
        post: post
  # list post by categories 
  app.get '/p/categories/:cate',(req,res)->
    catePage req,res,req.params.cate,1
  app.get '/p/categories/:cate/:page',(req,res)->
    catePage req,res,req.params.cate,req.params.page
  # render admin page
  app.get '/admin',(req,res)->
    adminPage req,res,1
  app.get '/admin/list/:page',(req,res)->
    adminPage req,res,req.params.page
  app.get '/admin/post',(req,res)->
    checkLogin req,res
    Post.getTags (err,tags)->
      res.render 'post',
        title: setting.title
        brand: setting.brand
        motto: setting.motto
        index: setting.nav.index
        about: setting.nav.about
        categories: setting.categories
        user: req.session.user 
        tags:tags
  # edit post page
  app.get '/admin/p/edit/:id',(req,res)->
    checkLogin req,res
    postId = req.params.id
    if postId.length isnt 24
      res.render '404'
      return false
    Post.getPostById postId,(err,docs)->
      console.log err if err
      Post.getTags (err,tags)->
        console.log err if err
        res.render "edit",
         title: setting.title
         brand: setting.brand
         index: setting.nav.index
         about: setting.nav.about
         list: setting.admin.list
         post: setting.admin.post
         posts: docs
         user: req.session.user
         tags: tags
  # check user is login
  checkLogin = (req,res)->
    res.redirect "/login" if not req.session.user?
  # index common page
  indexPage = (req,res,page)->
    page = 1 if page < 1
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
          location: '/index'
          widgets: renderWidgets()
          isFirstPage: (args.page - 1) == 0
          isLastPage: ((args.page - 1)*args.pageSize + posts.length) == total
          user: req.session.user 
   # categories common page
   catePage = (req,res,cate,page)->
     page = 1 if page < 1
     args = 
      condition:
        categories:cate
      page: page
      pageSize: 10
     Post.getTotal args,(err,total)->
      Post.getPostByCate args,(err,posts)->
          posts.forEach (post)->
            post.post = markdown.toHTML post.post
          res.render 'categories',
            title: setting.title
            brand: setting.brand
            motto: setting.motto
            index: setting.nav.index
            about: setting.nav.about
            posts: posts
            page: args.page
            cate: req.params.cate
            location: '/p/categories/'+req.params.cate
            isFirstPage: (args.page - 1) == 0
            isLastPage: ((args.page - 1)*args.pageSize + posts.length) == total
            widgets: renderWidgets()
            user: req.session.user 
   # widgets collections
   renderWidgets = ->
     widgets = {}
     widgets.categories = setting.categories
     recentsArgs = 
       condition: ''
       page: 1
       pageSize: 1
     # to fixed the bug
     Post.getRecents recentsArgs,(err,posts)->
       widgets.recents = posts
     return widgets
   # admin common info
   adminPage = (req,res,page)->
    checkLogin req,res
    page = parseInt page
    page = 1 if page < 1
    args = {
      condition: ''
      page: page
      pageSize: 10
    }
    Post.getTotal args,(err,total)->
      console.log total
      Post.getPosts args,(err,posts)->
        console.log err if err
        res.render "admin",
          title: setting.title
          brand: setting.brand
          index: setting.nav.index
          about: setting.nav.about
          user: req.session.user
          list: setting.admin.list
          post: setting.admin.post
          posts: posts
          page:args.page
          isFirstPage: (args.page - 1) == 0
          isLastPage: ((args.page - 1) * args.pageSize + posts.length) == total
          numPage:Math.ceil(total/10)
