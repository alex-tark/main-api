express      = require 'express'
mongoose	 = require 'mongoose'
path         = require 'path'
logger		 = require 'morgan'
cookieParser = require 'cookie-parser'
bodyParser   = require 'body-parser'
config			 = require './config'

app = express()

# Application configuration
app.set "port", process.env.PORT or 3000
app.set 'storage-uri', config.mongoose
app.set 'main-secret', config.secret
app.set 'models', path.join(__dirname, 'models')

app.use logger('dev')
app.use bodyParser.json()
app.use bodyParser.urlencoded({ extended: false })
app.use cookieParser()
	
# Connect to Mongo
mongoose.connect app.get('storage-uri'), { db: { safe: true } }, (err) ->
  console.log "Mongoose - connection error: " + err if err?
  console.log "Mongoose - connection OK"

# Application main controller
app.use '/', require './controllers'

app.use (req, res, next) ->
	err = new Error 'Not Found'
	err.status = 404
	next(err)
	
if app.get('env') == 'development'
	app.use (err, req, res, next) ->
		res.status err.status || 500 
		res.render 'error', {
			message: err.message
			error: err
		}

app.use (err, req, res, next) ->
	res.status err.status || 404
	require('./controllers/helpers').jsonResponse res, false, "Not found", 404, []


module.exports = app