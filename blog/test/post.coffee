Post = require '../models/post'
getArchive = ->
  Post.getArchive (err,time)->
    console.log time
getArchive()
