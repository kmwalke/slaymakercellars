Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :xero_oauth2,
    ENV['XERO_ID'],
    ENV['XERO_SECRET'],
    scope: %w[
      openid
      profile
      email
      files
      accounting.transactions
      accounting.transactions.read
      accounting.reports.read
      accounting.journals.read
      accounting.settings
      accounting.settings.read
      accounting.contacts
      accounting.contacts.read
      accounting.attachments
      accounting.attachments.read
      offline_access
    ].join(' ')
  )
end
