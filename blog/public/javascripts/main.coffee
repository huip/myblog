$(document).ready ->
  class Login
    constructor:->
      @init()
    $email = $ '.login-email'
    $password = $ '.login-password'
    $btn = $ '.login-btn'
    url = '/api/u/login'
    init: ->
      events()
    events = ->
      $btn.click ->
        doLogin()
    doLogin = ->
      datas = 
        email:$email.val()
        password:$password.val()
      $.ajax
        url: url
        type: 'post'
        data: datas
        success:(msg)->
          if msg.status_code == 202
            window.location.href = 'admin'
          else if msg.errorCode == 103
            alert '用户名不存在！'
          else if msg.errorCode == 104
            alert '用户名或密码错误！'
  class Register
    constructor: ->
      @init()
    $uname = $ ".register-username"
    $email = $ ".register-email"
    $password = $ ".register-password"
    $btn = $ ".register-btn"
    url =  "/api/u/register"
    init: ->
      events()
    events = ->
      $btn.click ->
        doRegister()
    doRegister = ->
      datas =
        username: @$uname.val()
        email: @$email.val()
        password: @$password.val()
      $.ajax
        url: url
        type: 'post'
        data: datas
        success:(msg)->
          if msg.errorCode == 201
            window.location.href = '/admin'
            return false
          alert "账号已经存在！" if msg.errorCode == 101

  login = new Login()
  register = new Register()
