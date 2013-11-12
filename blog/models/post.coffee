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
  post =
    name: @name
    title: @title
    tags: @tags
    post: @post
    time: Post.getTime()
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
# get one artcle info by artical id type { "markdown","html" }
Post.getOne = (id,type,callback)->
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
            doc.post = markdown.toHTML doc.post if type == "html"
            callback err,doc
          else
            callback err,null
Post.remove = (id,callback)->
  mongodb.open (err,db)->
    callback err if err
    db.collection "posts",(err,collection)->
      if err
        mongodb.close()
        callback err
      collection.remove
        _id:new ObjectID(id)
        ,{w:1}
        ,(err)->
          mongodb.close()
          if err
            callback err
          callback null
Post.update = (args,callback)->
  mongodb.open (err,db)->
    callback err if err
    args.time = Post.getTime()
    db.collection "posts",(err,collection)->
      if err
        mongodb.close()
        callback err
      collection.update
        _id: new ObjectID(args.id)
        ,{$set:args},(err)->
          mongodb.close()
          callback err if err
          callback null
Post.getTags = (callback)->
  mongodb.open (err,db)->
    callback err if err
    db.collection "posts",(err,collection)->
      if err
        mongodb.close()
        callback err
      collection.distinct "tags",(err,docs)->
        mongodb.close()  
        callback err if err
        callback null,docs
Post.getTime = ()->
  date = new Date()
  time = {
    date: date
    year: date.getFullYear()
    month: date.getFullYear() + "-" + (date.getMonth() + 1)
    day: date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate()
    minute: date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate()+
            " " + date.getHours()+":"+ date.getMinutes()
  }
