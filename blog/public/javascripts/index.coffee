$(document).ready ()->
  $indexContainer = $(".index-container")
  $widgetsContainer = $(".site-widgets")
  $aboutContainer = $(".about-container")
  # arcile model get one article 
  ArticleModel = Backbone.Model.extend
    urlRoot: "/api/p/get"
    defaults:
      name: ""
      title: ""
      tags: ""
      post: ""
      time: ""
  # get series articles
  ArticlesModel = Backbone.Model.extend
    urlRoot: "/api/p/list/"
  # wdgets model
  WidgetsModel = Backbone.Model.extend
    urlRoot: "/api/widgets"
  # article  tag model
  TagArticlesModel = Backbone.Model.extend
    urlRoot: "/api/p/tag/list"
    url:()->
      baseUrl = _.result @,'urlRoot'
      baseUrl if @isNew()
      baseUrl+
      "/"+encodeURIComponent( @.get("tag") )+
      "/"+encodeURIComponent(@.get("page"))
  # article categories model
  CatArticlesModel = Backbone.Model.extend
    urlRoot: "/api/p/categories"
    url:()->
      baseUrl = _.result @,'urlRoot'
      baseUrl if @isNew()
      baseUrl+
      "/"+encodeURIComponent( @.get("cat") )+
      "/"+encodeURIComponent(@.get("page"))
  # one article view page
  ArticleView = Backbone.View.extend
    initialize:()->
      that = @
      article = new ArticleModel {id:@id} 
      article.fetch
        success:(data)->
          that.render( data.toJSON() )
    render:(data)->
      template = _.template $("#article-template").html(),data
      @$el.html template
  # index page show 
  IndexView = Backbone.View.extend
    initialize:()->
      that = @
      articles = new ArticlesModel {id:@id}
      articles.fetch
        success:(data)->
          that.render data.toJSON() 
    render:(data)->
      template = _.template $("#index-template").html(),{datas:data}
      @$el.html template
  # right tags cloud view
  WidgetsView = Backbone.View.extend
    initialize:()->
      that = @
      tags = new WidgetsModel()
      tags.fetch
        success:(data)->
          that.render data.toJSON()
    render:(data)->
      template = _.template $("#widgets-template").html(),{datas:data}
      @$el.html template
  # get all articles by tag name page
  TagArticlesView = Backbone.View.extend
    initialize:()->
      that = @
      tagList = new TagArticlesModel()
      tagList.set
        tag:@id.tag
        page:@id.page
      tagList.fetch
        success:(data)->
          that.render data.toJSON()
    render:(data)->
      template = _.template $("#tagarticle-template").html(),{datas:data}
      @$el.html template
  # get all articles by categories name page
  CatArticlesView = Backbone.View.extend
    initialize:()->
      that = @
      catList = new CatArticlesModel()
      catList.set
        cat:@id.cat
        page:@id.page
      catList.fetch
        success:(data)->
          that.render data.toJSON()
    render:(data)->
      template = _.template $("#categories-template").html(),{datas:data}
      @$el.html template
  widgets = new WidgetsView {el:$widgetsContainer}
  AppRouter = Backbone.Router.extend
    routes :
      "" : "index"
      "index" : "index"
      "index/:id" : "index"
      "about" : "about"
      "p/:id" : "p"
      "p/tag/:tag":"tag"
      "p/categories/:cat" : "cat"
      "p/categories/:cat/:page" : "cat"
      "p/tag/:tag/:page" : "tag"
  appRouter = new AppRouter
  appRouter.on "route:index",(id)->
    $(".navbar-nav li").eq(0).addClass("active").siblings().removeClass("active")
    $indexContainer.show()
    $aboutContainer.hide()
    id = 1 if id == undefined
    indexView = new IndexView {el: $indexContainer,id:id}
  appRouter.on "route:about",()->
    $(".navbar-nav li").eq(1).addClass("active").siblings().removeClass("active")
    $aboutContainer.show()
    $indexContainer.hide()
  appRouter.on "route:p",(id)->
    $(".navbar-nav li").removeClass("active")
    $aboutContainer.hide()
    $indexContainer.show()
    articleView = new ArticleView {el: $indexContainer,id:id}
  appRouter.on "route:tag",(tag,page)->
    $(".navbar-nav li").removeClass("active")
    $indexContainer.show()
    $aboutContainer.hide()
    page = 1 if page ==  undefined
    args =
      page:page
      tag:tag
    tagArticlesView = new TagArticlesView {el:$indexContainer,id:args}
  appRouter.on "route:cat",(cat,page)->
    $(".navbar-nav li").removeClass("active")
    $indexContainer.show()
    $aboutContainer.hide()
    page = 1 if page ==  undefined
    args =
      page:page
      cat:cat
    catArticlesView = new CatArticlesView {el:$indexContainer,id:args}
    
  Backbone.history.start()
