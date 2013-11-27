$(document).ready ()->
  class Login
    constructor:->
    $email = $ '.login-email'
    $password = $ '.login-password'
    $btn = $ '.login-btn'
    url = '/api/u/login'
    init:()->
      events()
    events = ()->
      $btn.click ->
        doLogin()
    doLogin = ()->
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
  login = new Login()
  login.init()
