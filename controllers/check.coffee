jwt  = require 'jsonwebtoken'
user = require '../models/user'

config = require '../config'
helper = require './helpers'

module.exports = (req, res, next)  =>
  token = req.body.token || req.query.token || req.headers['x-access-token']
  
  if token?
    jwt.verify token, config.secret, (err, decoded) =>
      return helper.jsonResponse res, false, err, 401, [] if err?

      user.find({ "username": decoded._doc.username }).then (response) =>
        return helper.jsonResponse res, false, err, 401, [] if err?

        req.decoded = response
        next()
  else
    helper.jsonResponse res, false, "No token", 401, []