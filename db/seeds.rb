#!/bin/env ruby
# encoding: utf-8

# The comment at the top is needed to let us insert unicode from this source file

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(username: 'user', email: 'user@name.com', password: 'password', password_confirmation: 'password')
User.create(username: 'joe', email: 'joe@theplumber.com', password: 'joeplumber', password_confirmation: 'joeplumber')
User.create(username: 'fred', email: 'fred@fredtastic.com', password: 'freddy', password_confirmation: 'freddy')
User.create(username: 'ford', email: 'ads@ford.com', password: 'fordautos', password_confirmation: 'fordautos')
User.create(username: 'samsung', email: 'ads@samsung.com', password: 'samsungs', password_confirmation: 'samsungs')
User.create(username: 'adviewer', email: 'ads@viewer.com', password: 'adviewer', password_confirmation: 'adviewer')

Snop.create(
	user_id: 1, 
	uri: 'http://www.theglobeandmail.com/news/world/12-dead-after-masked-gunman-opens-fire-at-batman-premiere/article4429306/',
	title: "71 people shot, 12 fatally at Colorado theatre's Batman premiere",
	point1: 'Point 1',
	point2: 'Point 2',
	point3: 'Point 3',
	summary: 'My summary'
	)

Snop.create(
	user_id: 2, 
	uri: 'http://www.theglobeandmail.com/news/politics/ottawa-stalls-khadr-repatriation-with-new-roadblock/article4430435/',
	title: 'Ottawa stalls Khadr repatriation with new roadblock',
	point1: 'Point 1',
	point2: 'Point 2',
	point3: 'Point 3',
	summary: 'My summary'
	)

Snop.create(
	user_id: 3, 
	uri: 'http://www.economist.com/node/21559367',
	title: 'How long can the regime last?',
	point1: 'Point 1',
	point2: 'Point 2',
	point3: 'Point 3',
	summary: 'My summary'
	)

# Another snop about the same resource by a different user
Snop.create(
	user_id: 1, 
	uri: 'http://www.economist.com/node/21559367',
	title: "The regime won't last long!",
	point1: 'Point 1',
	point2: 'Point 2',
	point3: 'Point 3',
	summary: 'My summary is different!'
	)

# Create some ads -- these will be used by the ad demo user
Snop.create(
	user_id: 4,
	uri: 'http://www.ford.com',
	title: 'SPONSORED: Ford - New Cars, Trucks, SUVs, Hybrids & Crossovers',
	point1: 'Electric Vehicle Technology: Intelligent engine designs combine impressive performance with efficiency.',
	point2: 'SYNC® and SYNC® with MyFord Touch®: Revolutionizing the way you interact with your vehicle.',
	point3: 'EcoBoost®Engine: The power of a V8. The fuel-efficiency of a V6.',
	summary: 'Pushing the boundaries of what a vehicle can do.',
	is_ad: true
	)

Snop.create(
	user_id: 5,
	uri: 'http://www.samsung.com',
	title: 'SPONSORED: Samsung Galaxy S III - Share. Interact. Experience Smarter.',
	point1: 'The Galaxy S III is as powerful as it is stylish. For starters, the camera has 8.0 megapixels and absolutely zero shutter lag, so you can catch memories the moment you press the shutter.',
	point2: 'The Galaxy S III makes sharing easier than ever. With preloaded AllShare® Play, content can be sent instantly to friends and groups of devices. Or download Dropbox, Instagram and more, and keep your connections even more connected—to you.',
	point3: 'Transform a text chat into conversation just by raising the phone to your ear. Perform functions, search the web and simply get answers to anything you want, just by using your voice.',
	summary: 'Advanced. Intuitive. Simple. From the cutting edge technology inside to the stylish design that rests comfortably in your hand, the Galaxy S III makes everything you do easier.',
	is_ad: true
	)

# Required to index the snops we've created
# http://stackoverflow.com/questions/8088686/sunspot-not-indexing-objects-created-in-rake-tasks
Sunspot.index
Sunspot.commit