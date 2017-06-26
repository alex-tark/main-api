# Comment model to work with `comments` collection in DB
class CommentModel
  # Basic class constructor
  #
  # @param [String] comment Connection with Mongoose collection `comments`
  constructor: (@comment) ->


  # Creating new Comment model in DB
  #
  # @param [Object] data Comment data
  create: (data) =>
    return new Promise (fulfill, reject) =>
      return reject "Wrong data" if not data?

      Comment = new @comment data
      Comment.save (err, resource) =>
        return reject "Wrong data!" if err? || resource == {}
        fulfill "Comment has been created!"


  # Find Comment model in DB by title
  #
  # @param [String] query Comment query
  find: (query) =>
    return new Promise (fulfill, reject) =>
      return fulfill "Wrong data" if not query?

      @comment.find(query).exec (err, comment) =>
        return reject "Comment has not founded!" if err? || not comment?

        fulfill comment


  # Updating Comment model in DB
  #
  # @param [Object] data Comment data
  update: (query, data) =>
    return new Promise (fulfill, reject) =>
      return reject "Wrong data" if not data?

      @comment.findOneAndUpdate(query, data).exec (err, comment) =>
        return reject err if err?
        return reject "Wrong data" if comment == null || not comment?

        fulfill comment


  # Deleting Comment model in DB
  #
  # @param [Object] _id Comments id
  delete: (_id) =>
    return new Promise (fulfill, reject) =>
      return fulfill "Wrong data" if not _id?

      @comment.findOneAndRemove({ "_id": require('mongoose').Types.ObjectId(_id) }).exec (err, comment) =>
        return reject "Comment has not founded!" if err?

        fulfill comment

module.exports = new CommentModel require('../db').CommentModel