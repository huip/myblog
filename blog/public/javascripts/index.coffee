$(document).ready ()->
  $loginContainer = $('.login-container')
  $registerContainer = $('.register-container')
  UserModel = Backbone.Model.extend
    urlRoot: "/api/u/register"
    defaults:
      username: ""
      email: ""
      password: ""

  LoginView = Backbone.View.extend
    initialize: ()->
      this.render()
    render: ()->
      template = _.template( $("#login-template").html(),{} )
      this.$el.html template
    events: ()->
      "click #login-btn" : "doLogin"
    doLogin: ()->
      email = $(".login-email")
      password = $(".login-password")
      datas = {email:email.val(),password:password.val()}
      $.ajax
        url: "api/u/login"
        type: "post"
        data: datas
        success: (data)->
          if data.status_code == 202
            window.location.href = "/"
          else if data.status_code == 103
            alert "用户名不存在！"
          else if data.status_code == 104
            alert "用户名或密码错误！"

  RegisterView = Backbone.View.extend
    initialize: ()->
      this.render()
    render: ()->
      template = _.template( $("#register-template").html(),{} )
      this.$el.html template
    events:
      "click #register-btn" : "doRegister"
    doRegister: ()->
      username = $(".register-username").val()
      email = $(".register-email").val()
      password = $(".register-password").val()
      user = new UserModel()
      userDetails =
        username:username
        email: email
        password: password
      user.save userDetails,{
        success: (model,response)->
         alert "注册成功!" if response.status_code == 201
         alert "用户名或密码已经存在！" if response.status_code == 101
            
      }

  AppRouter = Backbone.Router.extend
    routes :
      "" : "index"
      "index" : "index"
      "about" : "about"
      "login" : "login"
      "register" : "register"
  appRouter = new AppRouter
  appRouter.on "route:index",()->
    $loginContainer.hide()
  appRouter.on "route:about",()->
    $loginContainer.hide()
    $registerContainer.hide()
  appRouter.on "route:login",()->
    $loginContainer.show()
    $registerContainer.hide()
    loginView = new LoginView {el: $loginContainer}
  appRouter.on "route:register",()->
    $registerContainer.show()
    $loginContainer.hide()
    registerView = new RegisterView {el: $registerContainer}
  Backbone.history.start()
