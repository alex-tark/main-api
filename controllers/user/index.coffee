router = require('express').Router()

user   = require '../../models/user'
helper = require '../helpers'

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

module.exports = router