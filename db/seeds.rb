# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

u = User.new
u.name = 'Dev Example User'
u.email = 'eric_mittler@mac.com'
u.uid = 'some-long-uuid'
u.aka = 'Eric'
u.event_manager = true
u.save!