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
# get total post
Post.getTotal = (args,next)->
  Post.find(args.condition).count().exec next
# get posts
Post.getPosts = (args,next)->
  Post.find(args.condition).skip((args.page-1)*args.pageSize).limit(args.pageSize).sort('-time').exec next
# get post by post id
Post.getPostById = (id,next)->
  Post.findOne({_id:new ObjectID(id)}).exec (err,post)->
    if post?
      next null,post
    else 
      next err,null
# get rencent posts
Post.getRecents = (args,next)->
  Post.getPosts args,next
# get posts by cate
Post.getPostByCate = (args,next)->
  Post.getPosts args,next
# update post
Post.update = (args,next)->
  post = new Post
  post.modify args,next
# post add 
Post.add = (args,next)->
  post = new Post
  post.save args,next

Post::modify = (info,next)->
  @_id = info.id
  @name = info.name
  @title = info.title
  @post = info.post
  @tags = info.tags
  @categories = info.categories
  @time = new Date()
  @save()

Post::save = (info,next)->
  @name = info.name
  @title = info.title
  @post = info.post
  @tags = info.tags
  @categories = info.categories
  @pv = 0
  @time = new Date()
  @save()
  next null,info

# remove post
Post.remove = (id,next)->
  Post.findOne({_id:new ObjectID(id)}).exec (err,post)->
    if err
      next err,null
    else
      post.remove()
      next null,post
# get tags
Post.getTags = (next)->
  Post.find().distinct('tags').exec next
