$(document).ready ()->
  AdminAction = 
    postUrl:""
    $postTitle: $ ".post-title"
    $postCate: $ ".post-cate"
    $postContent: $ ".post-content"
    $postBtn: $ ".post-btn"
    
    init:()->
      @event()
    event:()->
      @$postBtn.click ()->
        AdminAction.doPost()
    doPost:()->
      datas = {
        title: @$postTitle.val()
        cate: @$postCate.val()
        content: @$postContent.val()
      }
      $.ajax
        url: @postUrl
        type: "POST"
        data:datas
        success:(data)->
          alert data
        
  AdminAction.init()
