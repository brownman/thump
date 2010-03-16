# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_thump_session',
  :secret      => '777012d879a1928ca8c852fb08e10d99ab237e8162aded794c659d1f853f2aaab2baaddbdaed9a6a8a59ea562094caae50a830043ae46dd2923a61f3dfaa091d'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
