mongoose = require '../lib/mongoose'
ObjectID = require("mongodb").ObjectID
ParseDate = require '../middlewares/timeparse'
postSchema = new mongoose.Schema
  author: String
  title: String
  tags: String
  post: String
  categories: String
  time:
    date: String
    year: String
    month: String
    day: String
    minutes: String
    seconds: String
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
Post.modify = (args,author,next)->
  Post.findOne({_id:ObjectID(args.id)}).exec (err,post)->
    try
      post.time = Post.getTime()
      post.tags = args.tags
      post.post = args.post
      post.title = args.title
      post.save()
      next null,post
    catch err
      next err,null
# post add 
Post.add = (args,author,next)->
  post = new Post
  try
    post.author = author
    post.title = args.title
    post.pv = 0
    post.categories = args.categories
    post.tags = args.tags
    post.post = args.post
    post.time = Post.getTime()
    post.save()
    next null,post
  catch err
    next err,null
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
# get local time
Post.getTime = ->
  date = new Date()
  time =
    date: date
    year: ParseDate(date).getYear()
    month: ParseDate(date).getMonth()
    day: ParseDate(date).getDay()
    minutes: ParseDate(date).getMinutes()
    seconds: ParseDate(date).getSeconds()
  return time
