mongoose = require '../lib/mongoose'
ObjectID = require("mongodb").ObjectID
ParseDate = require '../middlewares/timeparse'
postSchema = new mongoose.Schema
  author: String
  title: String
  tags: Array
  post: String
  categories: String
  date: Date
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
  Post.find(args.condition).skip((args.page-1)*args.pageSize).limit(args.pageSize).sort('-date').exec next
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
Post.getPostByWidgets = (args,next)->
  Post.getPosts args,next
# update post
Post.modify = (args,author,next)->
  Post.findOne({_id:ObjectID(args.id)}).exec (err,post)->
    try
      post.time = getTime()
      post.tags = args.tags
      post.post = args.post
      post.title = args.title
      post.date = new Date()
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
    post.time = getTime()
    post.date = new Date()
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
  Post.find().exec (err,posts)->
    tags = {}
    for post in posts
      for tag in  post.tags
        tag = parseTag tag
        for item in tag
          tags[item]?=0
          tags[item]++
    result = []
    for tag in Object.keys tags
      result.push tag 
    next null,result
    
    #console.log parseTag tags
# get archive 
Post.getArchive = (next)->
  Post.find().distinct('time.month').exec next
# add pv
Post.addPv = (id,next)->
  Post.findOne({_id:ObjectID(id)}).exec (err,post)->
    post.pv = post.pv+1
    post.save()
    next null,post
# get local time
getTime = ->
  date = new Date()
  time =
    date: date
    year: ParseDate(date).getYear()
    month: ParseDate(date).getMonth()
    day: ParseDate(date).getDay()
    minutes: ParseDate(date).getMinutes()
    seconds: ParseDate(date).getSeconds()
  time
# parse tags
parseTag = (tags)->
  return [] if not tags
  tags = tags.split ','
  for i of tags
    tags[i] = tags[i].trim()
  tags
