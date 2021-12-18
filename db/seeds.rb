# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

description = 'This is the description. ' * 20
user1       = User.create(email: 'kent@slaymakercellars.com', name: 'kent', password: '123')
User.create(email: 'cris@slaymakercellars.com', name: 'cris', password: '123')

Product::CATEGORIES.each do |category|
  Product.create(name: "#{category}_1", price_point: 10, description: description, category: category,
                 xero_code: "#{category}_1"[-6..].upcase)
  Product.create(name: "#{category}_2", price_point: 12, description: description, category: category,
                 xero_code: "#{category}_2"[-6..].upcase)
  Product.create(name: "#{category}_3", price_point: 12, description: description, category: category,
                 xero_code: "#{category}_3"[-6..].upcase)
  Product.create(name: "#{category}_4", price_point: 14, description: description, category: category,
                 xero_code: "#{category}_4"[-6..].upcase)

  Award.create(name: "2021 #{category}_award", product: Product.last)
end

co = State.create(name: 'Colorado', abbreviation: 'CO')

20.times do |i|
  Town.create(name: "Town #{i}", state: co)
end

Town.all.each do |town|
  rand(1..6).times do |i|
    contact_url = [true, false].sample == true ? 'http://www.thing.com' : nil
    contact     = Contact.create(name: "Contact_#{town.id}_#{i}", town: town, url: contact_url)

    rand(0..3).times do
      Note.create(body: 'This is a note.', contact: contact, created_by: user1)
    end

    rand(0..1).times do
      order = Order.create(contact: contact, delivery_date: rand(-1..14).days.from_now, created_by: user1)

      rand(1..3).times do
        product = Product.all.sample
        LineItem.create(order: order, product: product, quantity: (rand(1..3) * product.case_size) + rand(0..6))
      end
    end
  end
end
