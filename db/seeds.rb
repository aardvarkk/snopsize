# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(:username => 'user', :email => 'user@name.com', :password => 'password', :password_confirmation => 'password')
User.create(:username => 'joe', :email => 'joe@theplumber.com', :password => 'joeplumber', :password_confirmation => 'joeplumber')
User.create(:username => 'fred', :email => 'fred@fredtastic.com', :password => 'freddy', :password_confirmation => 'freddy')

Domain.create(:uri => 'http://www.theglobeandmail.com')
Domain.create(:uri => 'http://www.economist.com')

Resource.create(:uri => '/news/world/12-dead-after-masked-gunman-opens-fire-at-batman-premiere/article4429306')
Resource.create(:uri => '/news/politics/ottawa-stalls-khadr-repatriation-with-new-roadblock/article4430435')
Resource.create(:uri => '/node/21559367')

Snop.create(
	:user_id => 1, 
	:domain_id => 1,
	:resource_id => 1,
	:title => "71 people shot, 12 fatally at Colorado theatre's Batman premiere",
	:point1 => 'Point 1',
	:point2 => 'Point 2',
	:point3 => 'Point 3',
	:summary => 'My summary'
	)

Snop.create(
	:user_id => 2, 
	:domain_id => 1,
	:resource_id => 2,
	:title => 'Ottawa stalls Khadr repatriation with new roadblock',
	:point1 => 'Point 1',
	:point2 => 'Point 2',
	:point3 => 'Point 3',
	:summary => 'My summary'
	)

Snop.create(
	:user_id => 3, 
	:domain_id => 2,
	:resource_id => 3,
	:title => 'How long can the regime last?',
	:point1 => 'Point 1',
	:point2 => 'Point 2',
	:point3 => 'Point 3',
	:summary => 'My summary'
	)

# Required to index the snops we've created
# http://stackoverflow.com/questions/8088686/sunspot-not-indexing-objects-created-in-rake-tasks
Sunspot.index
Sunspot.commit