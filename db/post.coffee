mongoose = require 'mongoose'

PostSchema = new mongoose.Schema(
  title: { type: String, required: true, default: "undefined" }
  text:  { type: String, required: true, default: "undefined" }
  author: { type: Object, required: true, default: { username: "admin", user_id: "someid" } }
  tags: { type: Array, default: [] }
  likes: { type: Number, default: 0 }
  created_at: { type: Date, default: Date.now }
)

module.exports = mongoose.model "Post", PostSchema