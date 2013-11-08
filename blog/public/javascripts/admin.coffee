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
    init:()->
      @event()
    event:()->
      @$postBtn.click ()->
        AdminAction.doPost()
      @$removeBtn.click ()->
        AdminAction.removePost $ @
      @$editBtn.click ()->
        AdminAction.editPost $ @
    doPost:()->
      datas =
        title: @$postTitle.val()
        tags: @$postTags.val()
        post: @$postPost.val()
      $.ajax
        url: @postUrl
        type: "POST"
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

  AdminAction.init()
