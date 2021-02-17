source('R/spotifyPodcastAPI.R')

library(testthat)

#### Initializing Authentication Token ####

client_id = Sys.getenv('CLIENT_ID')
client_secret_id = Sys.getenv('CLIENT_SECRET_ID')
authentication_token = getAuthenticationToken(client_id = client_id, 
                                              client_secret_id = secret_id)

#### Testing getAuthenticationToken Function ####




#### Testing getPodcastID Function ####
test_that('A test to check if an error is returned when an invalid market ID is entered', 
          {
            expect_error(getPodcastID('Philosophize This!',market = 7),'d')
            expect_error(getPodcastID('Philosophize This!', market='AAA'),'d')
})

test_that('A test to ')