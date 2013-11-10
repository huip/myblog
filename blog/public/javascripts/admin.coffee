$(document).ready ()->
  AdminAction = 
    postUrl:"/api/p/add"
    editUrl:"/api/p/update/"
    $postTitle: $ ".post-title"
    $postTags: $ ".post-tags"
    $postPost: $ ".post-post"
    $postBtn: $ ".post-btn"
    $removeBtn: $ ".remove-article"
    $editPost: $ ".edit-post"
    $editTitle: $ ".edit-title"
    $editTags: $ ".edit-tags"
    $editBtn: $ ".edit-btn"
    $loginEmail:  $ ".login-email"
    $loginPassword: $ ".login-password"
    $loginBtn: $ ".login-btn"
    $regUname: $ ".register-username"
    $regEmail: $ ".register-email"
    $regPassword: $ ".register-password"
    $regBtn: $ ".register-btn"
    $preBtn: $ ".preview-btn"
    init:()->
      @event()
    event:()->
      @$postBtn.click ()->
        AdminAction.doPost()
      @$removeBtn.click ()->
        AdminAction.removePost $ @
      @$editBtn.click ()->
        AdminAction.editPost $ @
      @$loginBtn.click ()->
        AdminAction.doLogin()
      @$regBtn.click ()->
        AdminAction.doRegister()
      @$preBtn.click ()->
        AdminAction.prePost $ @
    doPost:()->
      datas =
        title: @$postTitle.val()
        tags: @$postTags.val()
        post: @$postPost.val()
      $.ajax
        url: @postUrl
        type: "post"
        data: datas
        success:(msg)->
          window.location.href = "/admin" if msg.status_code == 203
    removePost:(that)->
      isRemove = window.confirm "are your sure delte this article?"
      window.location.href = that.attr "href" if isRemove
    editPost:(that)->
      datas =
        title: @$editTitle.val()
        tags: @$editTags.val()
        post: @$editPost.val()
        id:that.attr "pid"
      $.ajax
        url:@editUrl+datas.id
        type: "post"
        data: datas
        success:(msg)->
          window.location.href = "/admin" if msg.status_code == 204
    doLogin:()->
      datas = 
        email:@$loginEmail.val()
        password:@$loginPassword.val()
      $.ajax
        url: "api/u/login"
        type: "post"
        data: datas
        success:(msg)->
          if msg.status_code == 202
            window.location.href = "/admin"
          else if msg.status_code == 103
            alert "用户名不存在！"
          else if msg.status_code == 104
            alert "用户名或密码错误！"
    doRegister:()->
      datas =
        username: @$regUname.val()
        email: @$regEmail.val()
        password: @$regPassword.val()
      $.ajax
        url: "/api/u/register"
        type: "post"
        data: datas
        success:(msg)->
          alert "注册成功!" if msg.status_code == 201
          alert "用户名或密码已经存在！" if msg.status_code == 101
    prePost:(that)->
     if that.hasClass "hide"
       $(".wmd-preview").css "display","none"
       $(".wmd-input").css "display","block"
       that.removeClass "hide"
     else 
       $(".wmd-input").css "display","none"
       $(".wmd-preview").css "display","block"
       that.addClass "hide"
  AdminAction.init()
