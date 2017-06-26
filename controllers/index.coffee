router = require('express').Router()

# Including user router controller
router.use '/user', require './user'

# Including authentithication router controller
router.use '/auth', require './auth'

# Including posts router controller
router.use '/posts', require './posts'

# Including comments router controller
router.use '/comments', require './comments'

router.get '/', (req, res, next) =>
	res.status(200).json { status: true, message: "Welcome to cs-api!" }
	
module.exports = router