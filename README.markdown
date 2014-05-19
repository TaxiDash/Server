# TaxiDash 

##Overview

TaxiDash is an open source taxi permit infrastructure for maintaining taxi driver accounts and allowing users to rate their drivers as well as query information about their taxi driver's permit status and average rating.

TaxiDash also provides invaluable taxi usage statistics such as where and when rides are occurring and relative cost of various taxi drivers (that is, how their rates compare to the estimate fare for any given trip). All usage data is reported anonymously to protect the privacy of the taxi rider.

##Quick Start

Edit the configuration file
 
    /config/initializers/constants.rb

to reflect the city name and ip address of the machine running TaxiDash.

Make sure you have *gem* installed and up to date then run

     bundle install 
     bundle exec rake db:migrate

Next, we will create our first admin user

     rails console
     admin = User.new(:username => "admin", :email => " admin@admin.com", :password => "password", :password_confirmation => "password", :admin => true)
     admin.save
     exit

Now we just have to start our server

     rails server

then navigate to **localhost:3000** in a browser to use TaxiDash!
