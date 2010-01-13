# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_golden-circle_session',
  :secret => '8b068c8720921fd9c69a2d02a7070657293c47b039ca87330b3f99d022d1e9caae93877c53490ab6e1544f10b7ab1366cae41fe946363098fa75d781bb21b176'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
