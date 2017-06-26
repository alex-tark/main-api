router  = require('express').Router()

user    = require '../../models/user'
post    = require '../../models/post'
comment = require '../../models/comment'
helper  = require '../helpers'

router.use require '../check'

# Get user info
#
# GET /user
router.get '/', (req, res, next) =>
  user.find({ "username": req.decoded.username }).then (response) =>
    helper.jsonResponse res, true, "#{req.decoded.username} profile", 200, response
  .catch (err) =>
    helper.jsonResponse res, false, err, 401, []


# Update user
#
# PUT /user
router.put '/', (req, res, next) =>
  data = {
    name: req.body.name
    username: req.body.username
    password: req.body.password
    email: req.body.email
  }

  user.find({ "username": req.decoded.username }).then (response) =>
    helper.jsonResponse res, false, "Wrong user data", 401, [] if response == []

    user.update(data).then (user) =>
      helper.jsonResponse res, true, "#{req.decoded.username} user has been updated", 200, response
    .catch (err) =>
      helper.jsonResponse res, false, err, 401, []

  .catch (err) =>
    helper.jsonResponse res, false, err, 401, []


# Make likes to articles
#
# GET /user/like/article?id=<id>
router.get '/like/article', (req, res, next) =>
  if req.query.id?
    user.find({ "username": req.decoded.username }).then (response) =>
      return helper.jsonResponse res, false, "Wrong data", 401, [] if response == [] or response == null

      return helper.jsonResponse res, false, "You don't have much coins to do that", 403, [] if response.coins < 50

      post.update({ "_id": require('mongoose').Types.ObjectId(req.query.id) }, { $inc: { 'likes': 1 } }).then (article) =>
        return helper.jsonResponse res, false, "Eternal error", 400, [] if article == []

        coins = 0
        coins = response.coins - 50 if response.coins >= 50
        user.update({ "username": req.decoded.username }, { $set: { 'coins': coins } }).then (user) =>
          helper.jsonResponse res, true, "#{req.decoded.username} spent 50 coins", 200, { coins: user.coins }
        .catch (err) =>
          helper.jsonResponse res, false, err, 403, []

      .catch (err) =>
        helper.jsonResponse res, false, err, 403, []

    .catch (err) =>
      helper.jsonResponse res, false, err, 403, []

  else
    helper.jsonResponse res, false, "Wrong request", 403, []


# Make likes to comments
#
# GET /user/like/comment?id=<id>
router.get '/like/comment', (req, res, next) =>
  if req.query.id?
    user.find({ "username": req.decoded.username }).then (response) =>
      return helper.jsonResponse res, false, "Wrong data", 401, [] if response == [] or response == null

      return helper.jsonResponse res, false, "You don't have much coins to do that", 403, [] if response.coins < 10

      comment.update({ "_id": require('mongoose').Types.ObjectId(req.query.id) }, { $inc: { 'likes': 1 } } ).then (comment) =>
        return helper.jsonResponse res, false, "Eternal error", 400, [] if comment == []

        coins = 0
        coins = response.coins - 10 if response.coins >= 10
        user.update({ "username": req.decoded.username }, { $set: { 'coins': coins } }).then (user) =>
          helper.jsonResponse res, true, "#{req.decoded.username} spent 50 coins", 200, { coins: user.coins }
        .catch (err) =>
          helper.jsonResponse res, false, err, 403, []

      .catch (err) =>
        helper.jsonResponse res, false, err, 403, []

    .catch (err) =>
      helper.jsonResponse res, false, err, 403, []

  else
    helper.jsonResponse res, false, "Wrong request", 403, []

module.exports = router