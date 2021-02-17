library(testthat)
library(wrappify)

test_check("wrappify")


# Assign user's credential requirements for spotify API use

client_id <- Sys.getenv('Spotify_client_id')
client_secret <- Sys.getenv('Spotify_client_secret')
get_authentication_token(client_id, client_secret)




# Testing the authentication function

test_that("Authorization function returns an string", {
  expect_is(get_authentication_token(client_id, client_secret), "character")
})
test_that("Authorization function returns NULL and warns user of invalid credentials", {
  expect_is(get_authentication_token(client_id, 'Bad credential'), "NULL")
  expect_message(get_authentication_token(client_id, 'Bad credential'), 'Token authentication unsuccessful. Check credentials and try again')
})




# Testing the Artist to ID converter

test_that('Artist ID converter can handle missing track arguments', {
  expect_is(getArtist_ID(), 'NULL')
  expect_message(getArtist_ID(), 'No artist string provided.')
})

rm(auth_token)
test_that('Artist ID converter can handle missing authentication token', {
  expect_is(getArtist_ID(track = 'cantaloupe island'), 'NULL')
  expect_message(getArtist_ID(track = 'cantaloupe island'), 'Authorization token not defined.')

})
get_authentication_token(client_id, client_secret)

test_that('Artist ID converter can handle failed searches', {
  expect_is(getArtist_ID(''), 'NULL')
  expect_is(getArtist_ID(' '), 'NULL')
  expect_message(getArtist_ID(''), 'Search failed with response status:')
  expect_message(getArtist_ID(' '), 'No artists found with input:')
})

test_that('Artist ID converter returns the correct dataframe', {
  expect_is(getArtist_ID('martin garex'), 'data.frame')
  expect_true(getArtist_ID('martin garex')[3] > 50)
  expect_true(getArtist_ID('martin garex')[1] == 'Martin Garrix')
})




# Testing the Track to ID converter

test_that('Track ID converter can handle missing track arguments', {
  expect_is(getTrack_ID(), 'NULL')
  expect_message(getTrack_ID(), 'No track string provided.')
})

rm(auth_token)
test_that('Track ID converter can handle missing authentication token', {

  expect_is(getTrack_ID(track = 'cantaloupe island'), 'NULL')
  expect_message(getTrack_ID(track = 'cantaloupe island'), 'Authorization token not defined.')

})
get_authentication_token(client_id, client_secret)

test_that('Track ID converter can handle failed searches', {
  expect_is(getTrack_ID(''), 'NULL')
  expect_is(getTrack_ID(' '), 'NULL')
  expect_message(getTrack_ID(''), 'Search failed with response status:')
  expect_message(getTrack_ID(' '), 'No tracks found with input:')
})

test_that('Track ID converter returns the correct dataframe', {
  expect_is(getTrack_ID('cantaloupe island'), 'data.frame')
  expect_true('Cantaloupe Island' %in% getTrack_ID('cantaloupe island')$Track.Name)
})




# Testing the Track Recommendation function (includes testing the query assembler function since it's a dependent function)

test_that('Track recommendation function can handle missing track arguments', {
  expect_is(getTrackRecommendations(), 'NULL')
  expect_message(getTrackRecommendations(), 'Not all seeds were provided')
})

rm(auth_token)
test_that('Track recommendation function can handle missing authentication token', {
  expect_is(getTrackRecommendations(seed_artists = 'herbie hancock',
                                    seed_genres = 'jazz',
                                    seed_tracks = '0sCeNwt8xRCMR4NhKpMyBe'), 'NULL')
  expect_message(getTrackRecommendations(seed_artists = 'herbie hancock',
                                         seed_genres = 'jazz',
                                         seed_tracks = '0sCeNwt8xRCMR4NhKpMyBe'), 'Authorization token not defined.')
})
get_authentication_token(client_id, client_secret)


test_that('Track recommendation function can handle failed searches', {
  expect_is(getTrackRecommendations(seed_artists = 'gggggggg',
                                    seed_genres = 'jazz',
                                    seed_tracks = '0sCeNwt8xRCMR4NhKpMyBe'), 'NULL')
  expect_is(getTrackRecommendations(seed_artists = 'herbie',
                                    seed_genres = 'gggggggg',
                                    seed_tracks = '0sCeNwt8xRCMR4NhKpMyBe'), 'list')
  expect_is(getTrackRecommendations(seed_artists = 'herbie',
                                    seed_genres = 'jazz',
                                    seed_tracks = 'gggggggg'), 'NULL')
})


test_that('Track recommendation function returns the correct dataframe', {
  expect_is(getTrackRecommendations(seed_artists = 'herbie',
                                    seed_genres = 'jazz',
                                    seed_tracks = '0sCeNwt8xRCMR4NhKpMyBe')[[1]], 'data.frame')
})

test_that('Track recommendation function works with vector inputs', {
  expect_is(getTrackRecommendations(seed_artists = c('Ummet Ozcan', 'Robin Schulz'),
                                    seed_genres = c('electro house', 'progressive house'),
                                    seed_tracks = c('4l3FIRSFBFf3YQGH07FMAS'))[[1]], 'data.frame')
})
