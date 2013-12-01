setting = require '../settings'
markdown = require('markdown').markdown
User = require '../models/user'
Post = require '../models/post'
Feed = require 'feed'
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
    getWidgets (err,widgets)->
      res.render 'about',
        title: 'about page'
        brand: setting.brand
        motto: setting.motto
        index: setting.nav.index
        about: setting.nav.about
        user: req.session.user 
        widgets: widgets
  # render rss
  app.get '/rss',(req,res)->
    feed = new Feed
      title: setting.title
      description: setting.motto
      link: 'huip.org'
      image: ''
      author:
        name: 'huip'
        email: 'penghui1012@gmail.com'
        link: 'huip.org/about'
    args =
      condition: ''
      page: 1
      pageSize: 10
    Post.getTotal args,(total)->
      args.pageSize = total
      Post.getPosts args,(err,posts)->
        posts.forEach (post)->
          post.post = markdown.toHTML post.post
        for key of posts
          feed.item
            title: posts[key].title.trim()
            link: 'http://huip.org/p/'+posts[key]._id
            description: posts[key].post.trim()
            date: new Date(posts[key].time.date)
        res.set 'Content-Type','text/xml'
        res.send feed.render 'rss-2.0'
  # render login page
  app.get '/login',(req,res)->
    res.render 'login',
      title: 'login page'
      brand: setting.brand
      motto: setting.motto
      index: setting.nav.index
      about: setting.nav.about
      user: req.session.user
  app.get '/logout',(req,res)->
    req.session.user = undefined
    res.redirect '/'
  # render register page
  app.get '/register',(req,res)->
    checkLogin req,res
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
    getWidgets (err,widgets)->
      Post.addPv postId,(err,post)->
        Post.getPostById postId,(err,post)-> 
           post.post = markdown.toHTML post.post
           console.log post.time
           res.render 'page',
            title: 'register page'
            brand: setting.brand
            motto: setting.motto
            index: setting.nav.index
            about: setting.nav.about
            user: req.session.user
            widgets: widgets
            post: post
  # list post by categories 
  app.get '/w/:widgets/:type',(req,res)->
    widgetsPage req,res,req.params.widgets,req.params.type,1
  app.get '/w/:widgets/:type/:page',(req,res)->
    widgetsPage req,res,req.params.widgets,req.params.type,req.params.page
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
         categories: setting.categories
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
    getWidgets (err,widgets)->
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
            widgets: widgets
            isFirstPage: (args.page - 1) == 0
            isLastPage: ((args.page - 1)*args.pageSize + posts.length) == total
            user: req.session.user
   # widgets common page {widgets means widgets type}
   widgetsPage = (req,res,widget,type,page)->
     page = 1 if page < 1
     args = 
      condition:''
      page: page
      pageSize: 10
     switch widget
       when 'categorie' then args.condition = 'categories':type
       when 'tag' then args.condition = 'tags':type
       when 'archive' then args.condition = 'time.month':type
     getWidgets (err,widgets)->
       Post.getTotal args,(err,total)->
        Post.getPostByWidgets args,(err,posts)->
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
              type: type
              widget: widget.toUpperCase()
              location: '/p/categories/'+req.params.cate
              isFirstPage: (args.page - 1) == 0
              isLastPage: ((args.page - 1)*args.pageSize + posts.length) == total
              widgets: widgets
              user: req.session.user 
   # widgets collections
   getWidgets =(next)->
     widgets = {}
     widgets.categories = setting.categories
     recentsArgs = 
       condition: ''
       page: 1
       pageSize: 5
     # to fixed the bug
     Post.getRecents recentsArgs,(err,posts)->
       widgets.recents = posts
       Post.getTags (err,tags)->
        widgets.tags = tags
        Post.getArchive (err,archive)->
          widgets.archive = archive
          next null,widgets
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
      Post.getPosts args,(err,posts)->
        posts.forEach (post)->
          console.log post.time
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
    getDate = ->
      date = new Date()
      time =
        date: date
        year: ParseDate(date).getYear()
        month: ParseDate(date).getMonth()
        day: ParseDate(date).getDay()
        minutes: ParseDate(date).getMinutes()
        seconds: ParseDate(date).getSeconds()
      return time
