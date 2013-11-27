mongoose = require '../lib/mongoose'
ObjectID = require("mongodb").ObjectID
postSchema = new mongoose.Schema
  name: String
  title: String
  tags: String
  post: String
  categories: String
  time: Date
  pv: Number
module.exports = Post = mongoose.model 'Post', postSchema
Post.getTotal = (args,next)->
  Post.find(args.condition).count().exec next
Post.getPosts = (args,next)->
  Post.find(args.condition).skip((args.page-1)*args.pageSize).limit(args.pageSize).sort('-time').exec next
Post.getPostById = (id,next)->
  Post.findOne({_id:new ObjectID(id)}).exec (err,post)->
    if post?
      next null,post
    else 
      next err,null
