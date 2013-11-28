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
          if msg.errorCode == 202
            window.location.href = 'admin'
          else if msg.errorCode == 103
            alert '用户名不存在！'
          else if msg.errorCode == 104
            alert '用户名或密码错误！'
  class Register
    constructor: ->
      @init()
    $uname = $ '.register-username'
    $email = $ '.register-email'
    $password = $ '.register-password'
    $btn = $ '.register-btn'
    url =  '/api/u/register'
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
          alert '账号已经存在！' if msg.errorCode == 101
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
      datas =
        title: $postTitle.val()
        tags: $postTags.val()
        post: $postPost.val()
        categories: $postCategories.val()
      $.ajax
        url: postUrl
        type: 'post'
        data: datas
        success:(msg)->
          window.location.href = '/admin' if msg.status_code == 203
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
        url:@editUrl+datas.id
        type: 'post'
        data: datas
        success:(msg)->
          window.location.href = '/admin' if msg.status_code == 204
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
          $('.post-tags').append( tagOption )
          $inptTag.css( 'display','none' ).val('')
          that.addClass 'hides'
  login = new Login()
  register = new Register()
  admin = new Admin()
