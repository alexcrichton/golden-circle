# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_golden-circle_session',
  :secret => '23bf77c8f4486895184f2ddf4e4fc7ae6f94a46831d6cf95659a272995ed4aaea1e3cc4754aae789a61e28d694debbbc6847d81532c4480fc899df38aabed5c3'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
