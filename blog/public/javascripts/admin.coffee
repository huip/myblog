$(document).ready ()->
  AdminAction = 
    postUrl:"/api/p/add"
    $postTitle: $ ".post-title"
    $postTags: $ ".post-tags"
    $postPost: $ ".post-post"
    $postBtn: $ ".post-btn"
    $removeBtn: $ ".remove-article"
    init:()->
      @event()
    event:()->
      @$postBtn.click ()->
        AdminAction.doPost()
      @$removeBtn.click ()->
        AdminAction.removePost $(this)
    doPost:()->
      datas = {
        title: @$postTitle.val()
        tags: @$postTags.val()
        post: @$postPost.val()
      }
      $.ajax
        url: @postUrl
        type: "POST"
        data:datas
        success:(msg)->
          window.location.href = "/admin" if msg.status_code == 203
    removePost:(that)->
     isRemove = window.confirm("are your sure delte this article?") 
     window.location.href = that.attr("href") if isRemove
      
  AdminAction.init()
