Thump
===

Thump is a location-aware social network built to demonstrate the use of Pusher, a real-time web service from New Bamboo.

Requirements
===

* rails               (>= 2.3.5)
* rspec               (>= 1.3.0)
* rspec-rails         (>= 1.3.0)
* cucumber            (>= 0.6.3)
* database_cleaner    (>= 0.5.0)
* jspec               (>= 3.3.3)
* haml                (>= 2.2.19)
* authlogic           (>= 2.1.3)
* inherited_resources (>= 0.9.2)
* pickle              (>= 0.2.2)

Installation
===

    rake gems:install
    rake db:create
    rake db:migrate
    script/server
   
Running test suite    
===

    rake spec
    rake cucumber
    jspec