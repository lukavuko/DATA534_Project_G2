source("LukasFunctions.R")

library(testthat)


# Run the user's basic package variable requirements
client_id = Sys.getenv('Spotify_client_id')
client_secret = Sys.getenv('Spotify_client_secret')

# Test that auth_token is assigned globally in the function call
get_authentication_token(client_id, client_secret)

test_that("Gets an authorization token")
# Test


