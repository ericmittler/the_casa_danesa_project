# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities => City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

developer = User.create!(:first_name => 'Developer',
                         :last_name => 'Example User',
                         :event_manager => true)
email = Email.create!(:user_id => developer.id,
                            :confirmed => true,
                            :primary => true,
                            :address => 'eric_mittler@mac.com')
AuthenticationProvider.create!(:provider => 'developer authentication',
                               :user_id => developer,
                               :uid => UUIDTools::UUID.timestamp_create.to_s)
