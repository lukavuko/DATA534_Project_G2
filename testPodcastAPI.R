source('R/spotifyPodcastAPI.R')

library(testthat)

#### Initializing Authentication Token ####

client_id = Sys.getenv('CLIENT_ID')
client_secret_id = Sys.getenv('CLIENT_SECRET_ID')
authentication_token = getAuthenticationToken(client_id = client_id, 
                                              client_secret_id = client_secret_id)

#### Testing getAuthenticationToken Function ####

test_that('A test to check if an error is returned on entering an invalid client or secret ID',
          {
            expect_error(getAuthenticationToken('abcd',1))
            expect_error(getAuthenticationToken('abcd','abcd'))
          })


#### Testing getPodcastID Function ####
test_that('A test to check if an error is returned on entering invalid market ID', 
          {
            expect_error(getPodcastID('Philosophize This!',market = 7))
            expect_error(getPodcastID('Philosophize This!', market='AAA'))
})

test_that('A test to ')