# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_gcircle_session',
  :secret      => 'b5c82d10c7c1888b460991049023b06c735da95506f8062747c7b39f4c4b9bd9aa84b2135ca43b7f19f862028d4a34886290c660ab0dab21b0542a147866235d'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
