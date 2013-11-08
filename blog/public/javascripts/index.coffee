$(document).ready ()->
  $indexContainer = $(".index-container")
  $loginContainer = $(".login-container")
  $registerContainer = $(".register-container")
  $articleContainer = $(".article-container")
  UserModel = Backbone.Model.extend
    urlRoot: "/api/u/register"
    defaults:
      username: ""
      email: ""
      password: ""
  ArticleModel = Backbone.Model.extend
    urlRoot: "/api/p/get"
    defaults:
      name: ""
      title: ""
      tags: ""
      post: ""
      time: ""
  ArticlesModel = Backbone.Model.extend
    urlRoot: "/api/p/list/"
  LoginView = Backbone.View.extend
    initialize:()->
      @render()
    render:()->
      template = _.template( $("#login-template").html(),{} )
      @$el.html template
    events:()->
      "click #login-btn" : "doLogin"
    doLogin:()->
      email = $(".login-email")
      password = $(".login-password")
      datas = {email:email.val(),password:password.val()}
      $.ajax
        url: "api/u/login"
        type: "post"
        data: datas
        success:(data)->
          if data.status_code == 202
            window.location.href = "/admin"
          else if data.status_code == 103
            alert "用户名不存在！"
          else if data.status_code == 104
            alert "用户名或密码错误！"

  RegisterView = Backbone.View.extend
    initialize:()->
      @render()
    render:()->
      template = _.template( $("#register-template").html(),{} )
      @$el.html template
    events:
      "click #register-btn" : "doRegister"
    doRegister:()->
      username = $(".register-username").val()
      email = $(".register-email").val()
      password = $(".register-password").val()
      user = new UserModel()
      userDetails =
        username:username
        email: email
        password: password
      user.save userDetails,{
        success:(model,response)->
         alert "注册成功!" if response.status_code == 201
         alert "用户名或密码已经存在！" if response.status_code == 101
      }
  ArticleView = Backbone.View.extend
    initialize:()->
      that = @
      article = new ArticleModel {id:@id} 
      article.fetch
        success:(data)->
          that.render( data.toJSON() )
    render:(data)->
      template = _.template( $("#article-template").html(),data )
      @$el.html template
  IndexView = Backbone.View.extend
    initialize:()->
      that = @
      articles = new ArticlesModel {id:@id}
      articles.fetch
        success:(data)->
          that.render( data.toJSON() )
    render:(data)->
      console.log data
      template = _.template( $("#index-template").html(),{articles:data} )
      @$el.html template
  AppRouter = Backbone.Router.extend
    routes :
      "" : "index"
      "index" : "index"
      "index/:id" : "index"
      "about" : "about"
      "login" : "login"
      "register" : "register"
      "p/:id" : "p"
  appRouter = new AppRouter
  appRouter.on "route:index",(id)->
    $loginContainer.hide()
    $registerContainer.hide()
    $articleContainer.hide()
    id = 1 if id == undefined
    indexView = new IndexView {el: $indexContainer,id:id}
  appRouter.on "route:about",()->
    $loginContainer.hide()
    $registerContainer.hide()
    $articleContainer.hide()
  appRouter.on "route:login",()->
    $loginContainer.show()
    $registerContainer.hide()
    $articleContainer.hide()
    loginView = new LoginView {el: $loginContainer}
  appRouter.on "route:register",()->
    $registerContainer.show()
    $loginContainer.hide()
    $articleContainer.hide()
    registerView = new RegisterView {el: $registerContainer}
  appRouter.on "route:p",(id)->
    $registerContainer.hide()
    $loginContainer.hide()
    $articleContainer.show()
    articleView = new ArticleView {el: $articleContainer,id:id}
    
  Backbone.history.start()
