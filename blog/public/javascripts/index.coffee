$(document).ready ()->
  $loginContainer = $('.login-container')
  $registerContainer = $('.register-container')
  UserModel = Backbone.Model.extend
    urlRoot: "/api/user"
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
        succeess: (user)->
          console.log user
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
