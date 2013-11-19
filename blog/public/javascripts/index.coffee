$(document).ready ()->
  $indexContainer = $(".index-container")
  $loginContainer = $(".login-container")
  $registerContainer = $(".register-container")
  $articleContainer = $(".article-container")
  $tagsContainer = $(".tags-container")
  $recentContainer = $(".recent-container")
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
  TagsModel = Backbone.Model.extend
    urlRoot: "/api/wigets/tags"
  # article  tag model
  TagWigetsModel = Backbone.Model.extend
    urlRoot: "/api/p/tag/list/"
  # recent article model 
  RecentWigetsModel = Backbone.Model.extend
    urlRoot: "/api/wigets/recent/"
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
      template = _.template $("#index-template").html(),{articles:data}
      @$el.html template
  # right tags cloud view
  TagsView = Backbone.View.extend
    initialize:()->
      that = @
      tags = new TagsModel()
      tags.fetch
        success:(data)->
          that.render data.toJSON()
    render:(data)->
      template = _.template $("#tags-template").html(),{tags:data}
      @$el.html template
  # get all articles by tag name page
  TagWigetsView = Backbone.View.extend
    initialize:()->
      that = @
      tagList = new TagWigetsModel {id:@id}
      tagList.fetch
        success:(data)->
          that.render data.toJSON()
    render:(data)->
      template = _.template $("#tagarticle-template").html(),{tagArticles:data}
      @$el.html template
  # get recent post wigets
  RecentWigetsView = Backbone.View.extend
    initialize:()->
      that = @
      recentPost = new RecentWigetsModel {id:5}
      recentPost.fetch
        success:(data)->
          that.render data.toJSON()
    render:(data)->
      template = _.template $("#recent-template").html(),{recents:data}
      @$el.html template
      
  # initial tagsView
  tagsView = new TagsView {el:$tagsContainer}
  recentView = new RecentWigetsView {el:$recentContainer}
  AppRouter = Backbone.Router.extend
    routes :
      "" : "index"
      "index" : "index"
      "index/:id" : "index"
      "about" : "about"
      "p/:id" : "p"
      "p/tag/:tag" : "tag"
  appRouter = new AppRouter
  appRouter.on "route:index",(id)->
    $indexContainer.show()
    $articleContainer.hide()
    id = 1 if id == undefined
    indexView = new IndexView {el: $indexContainer,id:id}
  appRouter.on "route:about",()->
    $articleContainer.hide()
    $indexContainer.hide()
  appRouter.on "route:p",(id)->
    $indexContainer.hide()
    $articleContainer.show()
    articleView = new ArticleView {el: $articleContainer,id:id}
  appRouter.on "route:tag",(tag)->
    $indexContainer.show()
    $articleContainer.hide()
    tagArticlesView = new TagWigetsView {el:$indexContainer,id:tag}
    
  Backbone.history.start()
