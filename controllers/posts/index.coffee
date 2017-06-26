router = require('express').Router()

post   = require '../../models/post'
helper = require '../helpers'

auth   = require '../check'

# Get all posts
#
# GET /posts
router.get '/', (req, res, next) =>
  post.find({}).then (response) =>
    helper.jsonResponse res, true, "All posts", 200, response
  .catch (err) =>
    helper.jsonResponse res, false, err, 401, []


# Get users posts
#
# GET /posts/my
router.get '/my', auth, (req, res, next) =>
  post.find({ "author": req.decoded.username }).then (response) =>
    helper.jsonResponse res, true, "#{req.decoded.username} posts", 200, response
  .catch (err) =>
    helper.jsonResponse res, false, err, 401, []


# Creating new post
#
# POST /posts
router.post '/', auth, (req, res, next) =>
  data = {
    title: req.body.title
    text: req.body.text
    author: req.decoded.username
    tags: req.body.tags
  }

  post.create(data).then (response) =>
    helper.jsonResponse res, true, "Post #{data.title} has been created", 200, response
  .catch (err) =>
    helper.jsonResponse res, false, err, 402, []


# Get post by id
#
# GET /posts/<id>
router.get '/:id', auth, (req, res, next) =>
  objIndex = require('mongoose').Types.ObjectId(req.params.id)

  post.find({ "_id": objIndex }).then (response) =>
    return helper.jsonResponse res, false, "Post not found", 404, [] if response == [] or not response?

    helper.jsonResponse res, true, "Post ##{req.params.id}", 200, response[0]
  .catch (err) =>
    helper.jsonResponse res, false, err, 401, []



# Update post by id
#
# PUT /posts/<id>
router.put '/:id', (req, res, next) =>
  data = {
    title: req.body.title
    text: req.body.text
    author: req.decoded.username
    tags: req.body.tags
  }

  objIndex = require('mongoose').Types.ObjectId(req.params.id)

  post.find({ "_id": objIndex, "author": req.decoded.username }).then (response) =>
    response = response[0]
    return helper.jsonResponse res, false, "Wrong user data", 402, [] if response.author != req.decoded.username

    post.update({ "author": data.author }, data).then (response) =>
      helper.jsonResponse res, true, "Post has been updated", 200, response
    .catch (err) =>
      helper.jsonResponse res, false, err, 401, []

  .catch (err) =>
    helper.jsonResponse res, false, err, 401, []


# Delete post by id
#
# DELETE /posts/<id>
router.delete '/:id', auth, (req, res, next) =>
  objIndex = require('mongoose').Types.ObjectId(req.params.id)

  post.find({ "_id": objIndex, "author": req.decoded.username }).then (response) =>
    response = response[0]
    return helper.jsonResponse res, false, "Wrong user data", 402, [] if response.author != req.decoded.username

    post.delete(response._id).then (response) =>
      helper.jsonResponse res, true, "Post has been removed", 200, response
    .catch (err) =>
      helper.jsonResponse res, false, err, 401, []

  .catch (err) =>
    helper.jsonResponse res, false, err, 401, []


module.exports = router