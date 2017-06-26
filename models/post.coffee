# Post model to work with `posts` collection in DB
class PostModel
  # Basic class constructor
  #
  # @param [String] user Connection with Mongoose collection `posts`
  constructor: (@post) ->


  # Creating new Post model in DB
  #
  # @param [Object] data Post data
  create: (data) =>
    return new Promise (fulfill, reject) =>
      return reject "Wrong data" if not data?

      Post = new @post data
      Post.save (err, resource) =>
        return reject "Wrong data!" if err? || resource == {}
        fulfill "Post #{data.title} has been created!"


  # Find Post model in DB by title
  #
  # @param [String] title Posts title
  find: (query) =>
    return new Promise (fulfill, reject) =>
      return fulfill "Wrong data" if not query?

      @post.find(query).exec (err, post) =>
        return reject "Post has not founded!" if err? || not post?

        fulfill post


  # Updating Post model in DB
  #
  # @param [Object] data  Post data
  # @param [Object] query Updating query
  update: (query, data) =>
    return new Promise (fulfill, reject) =>
      return reject "Wrong data" if not data?

      @post.findOneAndUpdate(query, data).exec (err, post) =>
        return reject err if err?
        return reject "Wrong data!" if post == null || not post?

        fulfill post


  # Deleting Post model in DB
  #
  # @param [Object] author Post author
  delete: (author) =>
    return new Promise (fulfill, reject) =>
      return fulfill "Wrong data" if not author?

      @post.findOneAndRemove({ "author": author }).exec (err, post) =>
        return reject "Post has not founded!" if err?

        fulfill post

module.exports = new PostModel require('../db').PostModel