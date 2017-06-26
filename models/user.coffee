bcrypt = require 'bcrypt-nodejs'
jwt  	 = require 'jsonwebtoken'
config = require '../config'

# User model to work with `users` collection in DB
class UserModel 
	# Basic class constructor
	#
	# @param [String] user Connection with Mongoose collection `users`
	constructor: (@user) ->
	
	
	# Creating new User model in DB
	#
	# @param [Object] data User data 
	create: (data) =>
		return new Promise (fulfill, reject) =>
			return reject "Wrong data" if not data?
			
			@user.findOne({ "username": data.username }).select("username").exec (err, user) =>
				return reject "Wrong data!" if err?
				return reject "Username #{data.username} is using now!" if user?
				
				User = new @user data
				User.save (err, resource) =>
					return reject "Wrong data!" if err? || resource == {}
					fulfill "User #{data.username} has been created!" 
	
	
	# Find User model in DB by username
	#
	# @param [String] query User query string
	find: (query) =>
		return new Promise (fulfill, reject) =>
			return fulfill "Wrong data" if not query?
			
			@user.findOne(query).select([ "name", "username", "email" ]).exec (err, user) =>
				return reject "Username #{username} is not defined!" if err? || not user?
				
				fulfill user
	
	
	# Comparing current User model with the same model in DB
	#
	# @param [Object] data User data 
	compare: (data) =>
		return new Promise (fulfill, reject) =>
			return reject "Wrong data" if not data?
			
			@user.findOne({ "username": data.username }).exec (err, user) =>
				return reject "Username #{data.username} is not defined!" if err? || not user?
				
				bcrypt.compare data.password, user.password, (err, valid) =>
					return reject "Not valid password" if err? || not valid

					token = jwt.sign user, config.secret, {
							expiresIn: 60*60*24
					}

					fulfill token
	
	
	# Updating User model in DB
	#
	# @param [Object] data User data 
	update: (data) =>
		return new Promise (fulfill, reject) =>
			return reject "Wrong data" if not data?
			
			@user.findOneAndUpdate({ "username": data.username }, data).select("password").exec (err, user) =>
				return reject "Wrong data!" if err?
				fulfill "User #{data.username} has been updated!" 

module.exports = new UserModel require('../db').UserModel