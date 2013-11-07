$(document).ready ()->
  AdminAction = 
    postUrl:"/api/p/add"
    $postTitle: $ ".post-title"
    $postTags: $ ".post-tags"
    $postPost: $ ".post-post"
    $postBtn: $ ".post-btn"
    init:()->
      @event()
    event:()->
      @$postBtn.click ()->
        AdminAction.doPost()
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
        success:(data)->
          console.log data
  AdminAction.init()
