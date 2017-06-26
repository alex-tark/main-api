mongoose = require 'mongoose'

CommentSchema = new mongoose.Schema(
  text:  { type: String, required: true, default: "undefined" }
  author: { type: Object, required: true, default: { username: "admin", user_id: "someid" } }
  likes: { type: Number, default: 0 }
  created_at: { type: Date, default: Date.now }
  post_id: { type: String, required: true }
)

module.exports = mongoose.model "Comment", CommentSchema