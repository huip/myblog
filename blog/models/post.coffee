mongoose = require '../lib/mongoose'
postSchema = new mongoose.Schema
  name: String
  title: String
  tags: String
  post: String
  categories: String
  time: Date
  pv: Number
module.exports = Post = mongoose.model 'Post', postSchema
Post.getPosts = (args,next)->
  Post.find(args.condition).skip((args.page-1)*args.pageSize).sort('-time').exec next
