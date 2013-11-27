mongoose = require '../lib/mongoose'
postSchema = new mongoose.Schema
  name: String
  title: String
  tags: String
  post: String
  categories: String
  time: Data
  pv: Number
module.exports = Post = mongoose model 'Post', postSchema
