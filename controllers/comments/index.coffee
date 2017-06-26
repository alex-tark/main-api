router = require('express').Router()

comment = require '../../models/comment'
helper  = require '../helpers'
auth    = require '../check'

# Get users comments
#
# GET /comments/my
router.get '/my', auth, (req, res, next) =>
  comment.find({ "author": req.decoded.username }).then (response) =>
    helper.jsonResponse res, true, "#{req.decoded.username} comments", 200, response
  .catch (err) =>
    helper.jsonResponse res, false, err, 401, []


# Get comments by post_id
#
# GET /comments/post/<id>
router.get '/post/:id', (req, res, next) =>
  #objIndex = require('mongoose').Types.ObjectId(req.params.id)

  comment.find({ "post_id": req.params.id }).then (response) =>
    helper.jsonResponse res, true, "Comments to post ##{req.params.id}", 200, response
  .catch (err) =>
    helper.jsonResponse res, false, err, 404, []


# Creating new comment to post
#
# POST /comments/<post_id>
router.post '/:post_id', auth, (req, res, next) =>
  data = {
    text: req.body.text
    author: req.decoded.username
    post_id: req.params.post_id
  }

  comment.create(data).then (response) =>
    helper.jsonResponse res, true, "Comment has been created", 200, response
  .catch (err) =>
    helper.jsonResponse res, false, err, 402, []

# Update comment by id
#
# PUT /comments/<id>
router.put '/:id', auth, (req, res, next) =>
  data = {
    text: req.body.text
    author: req.decoded.username
  }

  objIndex = require('mongoose').Types.ObjectId(req.params.id)

  comment.find({ "_id": objIndex, "author": req.decoded.username }).then (response) =>
    response = response[0]
    return helper.jsonResponse res, false, "Wrong user data", 402, [] if response.author != req.decoded.username
    data.post_id = response.post_id

    comment.update(data).then (response) =>
      helper.jsonResponse res, true, "Comment has been updated", 200, response
    .catch (err) =>
      helper.jsonResponse res, false, err, 401, []

  .catch (err) =>
    helper.jsonResponse res, false, err, 401, []


# Delete comment by id
#
# DELETE /comments/<id>
router.delete '/:id', auth, (req, res, next) =>
  objIndex = require('mongoose').Types.ObjectId(req.params.id)

  comment.find({ "_id": objIndex, "author": req.decoded.username }).then (response) =>
    response = response[0]
    return helper.jsonResponse res, false, "Wrong user data", 402, [] if response.author != req.decoded.username
    data.post_id = response.post_id

    comment.delete(response.author).then (response) =>
      helper.jsonResponse res, true, "Comment has been removed", 200, response
    .catch (err) =>
      helper.jsonResponse res, false, err, 401, []

  .catch (err) =>
    helper.jsonResponse res, false, err, 401, []


module.exports = router