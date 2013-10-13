$(document).ready ()->
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
  AppRouter = Backbone.Router.extend
    routes :
      "" : "index"
      "index" : "index"
      "about" : "about"
      "login" : "login"
      "register" : "register"
  appRouter = new AppRouter
  appRouter.on "route:index",()->
    $(".login-container").hide()

  appRouter.on "route:about",()->
    $(".login-container").hide()
    $(".register-container").hide()
  appRouter.on "route:login",()->
    $(".login-container").show()
    $(".register-container").hide()
    loginView = new LoginView {el: $(".login-container")}
  appRouter.on "route:register",()->
    $(".register-container").show()
    $(".login-container").hide()
    registerView = new RegisterView {el: $(".register-container")}
  Backbone.history.start()
