# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(email: 'kent@slaymakercellars.com', name: 'kent', password: '123')
User.create(email: 'cris@slaymakercellars.com', name: 'cris', password: '123')

Product.create(name: 'Traditional', price_point: 10, description: 'This is the description')
Product.create(name: 'Sweet Clover', price_point: 12, description: 'This is the description')

ar = State.create(name: 'Arkansas', abbreviation: 'AR')
co = State.create(name: 'Colorado', abbreviation: 'CO')

idaho_springs = Town.create(name: 'Idaho Springs', state: co)
georgetown    = Town.create(name: 'Georgetown', state: co)
little_rock   = Town.create(name: 'Little Rock', state: ar)

Contact.create(name: 'A bar', town: idaho_springs, url: 'http://www.thing.com')
Contact.create(name: 'A package store', town: idaho_springs, url: 'http://www.thing.com')
Contact.create(name: 'A restaurant', town: idaho_springs)
Contact.create(name: 'B bar', town: georgetown, url: 'http://www.thing.com')
Contact.create(name: 'B package store', town: georgetown, url: 'http://www.thing.com')
Contact.create(name: 'B restaurant', town: georgetown)
Contact.create(name: 'C bar', town: little_rock, url: 'http://www.thing.com')
Contact.create(name: 'C package store', town: little_rock, url: 'http://www.thing.com')
Contact.create(name: 'C restaurant', town: little_rock, url: 'http://www.thing.com')
