router = require('express').Router()

user   = require '../../models/user'
helper = require '../helpers'

router.post '/signup', (req, res, next) =>
	data = {
		name: req.body.name
		username: req.body.username
		password: req.body.password
		email: req.body.email
	}

	user.create(data).then (response) =>
		helper.jsonResponse res, true, response, 200, []
	.catch (err) =>
		helper.jsonResponse res, false, err, 401, []
	
router.post '/signin', (req, res, next) =>
	data = {
		username: req.body.username
		password: req.body.password
	}

	user.compare(data).then (response) =>
		helper.jsonResponse res, true, "You has been authorized!", 200, response
	.catch (err) =>
		helper.jsonResponse res, false, err, 401, []

module.exports = router