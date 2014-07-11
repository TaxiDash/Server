# Defining configuration variables here.
#
# As these variables are loaded on server startup, 
# changing any of these variables will require a
# TaxiDash server restart to take effect

# The ip address of the machine running TaxiDash
SERVER_ADDRESS = "68.53.106.44:3000"

# The name of the city using TaxiDash. This is used
# in branding of the app and notifying the smartphone
# users of the city they are connected to
CITY_NAME = "Nashville"
STATE_ABBREVIATION = "TN"

# Number of items to show up per page
# Fewer items will load faster
TABLE_ITEMS_PER_PAGE = 25

# Basic Fare rules
PER_MILE_RATE = 2
PER_PERSON_ADDITIONAL_CHARGE = 1
BASE_CHARGE = 3
