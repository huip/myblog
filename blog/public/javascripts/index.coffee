$(document).ready ()->
  $indexContainer = $(".index-container")
  $loginContainer = $(".login-container")
  $registerContainer = $(".register-container")
  $articleContainer = $(".article-container")
  $tagsContainer = $(".tags-container")
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
  TagsModel = Backbone.Model.extend
    urlRoot: "/api/tags"
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
          that.render( data.toJSON() )
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
      console.log data
      template = _.template $("#tags-template").html(),{tags:data}
      @$el.html template
  # initial tagsView
  tagsView = new TagsView {el:$tagsContainer}
  AppRouter = Backbone.Router.extend
    routes :
      "" : "index"
      "index" : "index"
      "index/:id" : "index"
      "about" : "about"
      "p/:id" : "p"
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
    
  Backbone.history.start()
