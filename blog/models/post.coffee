mongodb = require "./db"
markdown = require("markdown").markdown
ObjectID = require("mongodb").ObjectID
Post = (post)->
  @name = post.name
  @title = post.title
  @tags =  post.tags
  @post = post.post
module.exports = Post
Post.prototype.save = (callback)->
  date = new Date()
  time = {
    date: date
    year: date.getFullYear()
    month: date.getFullYear() + "-" + (date.getMonth() + 1)
    day: date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate()
    minute: date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate()+
            " " + date.getHours()+":"+ date.getMinutes()
  }
  post =
    name: @name
    title: @title
    tags: @tags
    post: @post
    time: time
    pv: 0
  mongodb.open (err,db)->
    callback err if err
    db.collection "posts",(err,collection)->
      if err
        mongodb.close()
        callback err
      collection.insert post,{safe:true},(err)->
        mongodb.close()
        callback err
# get article list args [limit,page]
Post.get = (args,callback)->
  mongodb.open (err,db)->
    callback err if err
    db.collection "posts",(err,collection)->
      if err
        mongodb.close()
        callback err
      query = {}
      query.name = args.name if args.name
      collection.count query,(err,total)->
       collection.find(query,{
         skip: (args.page-1)*args.limit
         limit:args.limit
       } ).sort(
         time:-1
       ).toArray (err,docs)->
        mongodb.close()
        callback err if err
        docs.forEach (doc)->
          doc.post = markdown.toHTML doc.post
        callback null,docs,total
# get one artcle info by artical id
Post.getOne = (id,callback)->
  mongodb.open (err,db)->
    callback err if err
    db.collection "posts",(err,collection)->
      if err
        mongodb.close()
        callback err
      collection.findOne
        _id:new ObjectID(id)
        ,(err,doc)->
          mongodb.close()
          if doc
            doc.post = markdown.toHTML doc.post
            callback err,doc
          else
            callback err,null
