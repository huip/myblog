$(document).ready ()->
  $indexContainer = $(".index-container")
  $tagsWidget = $(".cat-widget")
  $recentWidget = $(".recent-widget")
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
  # tag list model
  TagsWidgetsModel = Backbone.Model.extend
    urlRoot: "/api/widget/tags"
  # article  tag model
  TagArticlesModel = Backbone.Model.extend
    urlRoot: "/api/p/tag/list"
    url:()->
      baseUrl = _.result @,'urlRoot'
      baseUrl if @isNew()
      baseUrl+
      "/"+encodeURIComponent( @.get("tag") )+
      "/"+encodeURIComponent(@.get("page"))
  # recent article model 
  RecentWidgetsModel = Backbone.Model.extend
    urlRoot: "/api/widget/recent/"
  # month archive model
  MonthWidgetsModel = Backbone.Model.extend
    urlRoot: "/api/widget/month"
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
  TagsWidgetsView = Backbone.View.extend
    initialize:()->
      that = @
      tags = new TagsWidgetsModel()
      tags.fetch
        success:(data)->
          that.render data.toJSON()
    render:(data)->
      template = _.template $("#tags-template").html(),{datas:data}
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
  # get recent post wigets
  RecentWidgetsView = Backbone.View.extend
    initialize:()->
      that = @
      recentPost = new RecentWidgetsModel {id:5}
      recentPost.fetch
        success:(data)->
          that.render data.toJSON()
    render:(data)->
      template = _.template $("#recent-template").html(),{recents:data}
      @$el.html template
  # get month archive wigets
  MonthWidgetsView = Backbone.View.extend
    initialize:()->
      that = @
      month = new MonthWidgetsModel()
      month.fetch
        success:(data)->
          that.render data.toJSON()
    render:(data)->
      template = _.template $("#month-template").html() ,{months:data}
      @$el.html template
  # initial tagsView
  tagsWigetsView = new TagsWidgetsView {el:$tagsWidget}
  recentWigetsView = new RecentWidgetsView {el:$recentWidget}
  
  AppRouter = Backbone.Router.extend
    routes :
      "" : "index"
      "index" : "index"
      "index/:id" : "index"
      "about" : "about"
      "p/:id" : "p"
      "p/tag/:tag":"tag"
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
    
  Backbone.history.start()
