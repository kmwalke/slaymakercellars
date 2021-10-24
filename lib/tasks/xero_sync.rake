namespace :xero_sync do
  def log(msg)
    puts msg
    Rails.logger.info(msg)
  end

  task contacts: :environment do
    log('Connecting contacts to xero.....')

    user = User.find_by(name: 'kent')

    log('Could not find user named \'kent\'') && return if user.nil?

    contacts     = Contact.where(xero_id: nil)
    num_contacts = contacts.count

    contacts.each_with_index do |contact, i|
      xero_contact = Xero::Contact.create(user, contact)
      contact.update(xero_id: xero_contact.id)
      log("Local Id: #{contact.id} Xero Id: #{contact.reload.xero_id}")
      log("Contact Sync: #{((i.to_f / num_contacts) * 100).to_i}%")
      sleep 1
    end

    log('Finished connecting contacts to xero!')
  end
end
