router = require('express').Router()

user   = require '../../models/user'
helper = require '../helpers'

router.use require '../check'

router.get '/', (req, res, next) =>
  user.find({ "username": req.decoded.username }).then (response) =>
    helper.jsonResponse res, true, "#{req.decoded.username} profile", 200, response
  .catch (err) =>
    helper.jsonResponse res, false, err, 401, []

router.get '/posts', (req, res, next) =>
  post.find({ "author": req.decoded.username }).then (response) =>
    helper.jsonResponse res, true, "#{req.decoded.username} posts", 200, response
  .catch (err) =>
    helper.jsonResponse res, false, err or "Not found", 401, []

module.exports = router