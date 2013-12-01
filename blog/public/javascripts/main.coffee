$(document).ready ->
  class Login
    constructor:->
      @init()
    $email = $ '.login-email'
    $password = $ '.login-password'
    $errorTip = $ '.error-tip'
    $btn = $ '.login-btn'
    url = '/api/u/login'
    bok = false
    init: ->
      events()
    events = ->
      $btn.click ->
        doLogin()
      $email.focus ->
        errorTip $errorTip,'','hide'
      $password.focus ->
        errorTip $errorTip,'','hide'
    checkInvalid = (data) ->
      if not isValidEmail data.email
        errorTip $errorTip,'invalid email address!','show'
        bok = false 
      else if data.password.length < 6
        errorTip $errorTip,'password less than 6 charaters','show'
        bok = false
      else
        bok = true
      return bok
    msgHandle = (msg)->
      if msg.errorCode is 202
        window.location.href = '/admin'
      else if msg.errorCode is 103
        errorTip $errorTip,'user not exist!','show'
      else if msg.errorCode is 104
        errorTip $errorTip,'username or password error!','show'
    doLogin = ->
      data = 
        email:$email.val()
        password:$password.val()
      if checkInvalid data
        $.ajax
          url: url
          type: 'post'
          data: data
          success:(msg)->
            msgHandle msg 
  class Register
    constructor: ->
      @init()
    $uname = $ '.register-username'
    $email = $ '.register-email'
    $password = $ '.register-password'
    $btn = $ '.register-btn'
    $errorTip = $ '.error-tip'
    url =  '/api/u/register'
    bok = false
    init: ->
      events()
    events = ->
      $btn.click ->
        doRegister()
      $uname.focus ->
        errorTip $errorTip,'','hide'
      $email.focus ->
        errorTip $errorTip,'','hide'
      $password.focus ->
        errorTip $errorTip,'','hide'
    checkInvalid = (data) ->
      if data.username.length < 4
        errorTip $errorTip,'Invalid user name!','show'
      else if not isValidEmail data.email
        errorTip $errorTip,'Invalid email address!','show'
        bok = false 
      else if data.password.length < 6
        errorTip $errorTip,'Password less than 6 characters!','show'
        bok = false
      else
        bok = true
    msgHandle = (msg)->
      if msg.errorCode is 201
        window.location.href = '/admin'
        return false
      if msg.errorCode is 101
        errorTip $errorTip,'user acount is already exist','show'
    doRegister = ->
      data =
        username: $uname.val()
        email: $email.val()
        password: $password.val()
      if checkInvalid data
        $.ajax
          url: url
          type: 'post'
          data: data
          success:(msg)->
            msgHandle msg
  class Admin
    constructor: ->
      @init()
    postUrl = '/api/p/add'
    editUrl = '/api/p/update/'
    $postTitle = $ '.post-title'
    $postTags = $ '.post-tags'
    $postPost = $ '.post-post'
    $postCategories = $ '.post-categories'
    $postBtn =  $ '.post-btn'
    $removeBtn =  $ '.remove-article'
    $editPost =  $ '.edit-post'
    $editTitle =  $ '.edit-title'
    $editTags = $ '.edit-tags'
    $editBtn = $ '.edit-btn'
    $preBtn = $ '.preview-btn'
    $ctagBtn = $ '.create-tag'
    init: ->
      events()
    events = ->
      $postBtn.click ->
        doPost()
      $removeBtn.click ->
        removePost $ @
      $editBtn.click ->
        editPost $ @
      $preBtn.click ->
        prePost $ @
      $ctagBtn.click ->
        createTag $ @
    doPost = ->
      post =
        title: $postTitle.val()
        tags: $postTags.val()
        post: $postPost.val()
        categories: $postCategories.val()
      $.ajax
        url: postUrl
        type: 'post'
        data: post
        success:(msg)->
          window.location.href = '/admin' if msg.errorCode is '203'
    removePost = (that)->
      isRemove = window.confirm 'are your sure delte this article?'
      window.location.href = that.attr 'href' if isRemove
    editPost = (that)->
      datas =
        title: $editTitle.val()
        tags: $editTags.val()
        post: $editPost.val()
        id:that.attr 'pid'
      $.ajax
        url: editUrl+datas.id
        type: 'post'
        data: datas
        success:(msg)->
          window.location.href = '/admin' if msg.errorCode is '203'
    prePost = (that)->
     if that.hasClass 'hides'
       $('.wmd-preview').css 'display','none'
       $('.wmd-input').css 'display','block'
       that.removeClass 'hides'
     else 
       $('.wmd-input').css 'display','none'
       $('.wmd-preview').css 'display','block'
       that.addClass 'hides'
    createTag = (that)->
      $inptTag = $('.input-tag')
      if that.hasClass 'hides'
        $inptTag.css 'display','block'
        that.removeClass 'hides'
      else 
        if $inptTag.val() != ''
          tagOption = '<option value='+$inptTag.val()+'>'+$inptTag.val()+'</option>'
          $('.tags').append( tagOption )
          $inptTag.css( 'display','none' ).val('')
          that.addClass 'hides'
  class Router
    constructor: ->
      @url = window.location.href
      @init @url
    current = ''
    init:(url)->
      urlHash url
    urlHash = (url)->
      urls = url.split '/'
      current = urls[3]
    on:(router,next)->
      if router is current
        next null,router
      else 
        next 'not current',null

  # router config 
  router = new Router()
  router.on 'admin',(err,current)->
    if current
      admin = new Admin()
      $('.navbar-nav li').eq(2).addClass('active').siblings().removeClass('active')
  router.on 'index',(err,current)->
    if current
      $('.navbar-nav li').eq(0).addClass('active').siblings().removeClass('active')
  router.on 'login',(err,current)->
    if current
      $('.navbar-nav li').removeClass('active')
      login = new Login()
  router.on 'register',(err,current)->
    if current
      register = new Register()
      $('.navbar-nav li').removeClass('active')
  router.on 'about',(err,current)->
    if current
      $('.navbar-nav li').eq(1).addClass('active').siblings().removeClass('active')
  router.on 'p',(err,current)->
    if current 
      $('.navbar-nav li').removeClass('active')
  router.on 'w',(err,current)->
    if current 
      $('.navbar-nav li').removeClass('active')

 # is valid email
 isValidEmail = (email)->
   reMail = /^(?:[a-z\d]+[_\-\+\.]?)*[a-z\d]+@(?:([a-z\d]+\-?)*[a-z\d]+\.)+([a-z]{2,})+$/i
   return reMail.test email
 # error tip 
 errorTip = (dom,msg,method)->
   if method is 'show'
     dom.html(msg).css 'color','#b94a48'
   else
     dom.html ''
