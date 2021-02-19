#####################################
## Testing Track Recommendation
##
## This also tests the query assembler
## since it's a dependent function
#####################################

test_that('Track recommendation function can handle missing track arguments', {
  expect_true(is(getTrackRecommendations(), 'NULL'))
  expect_message(getTrackRecommendations(), 'Not all seeds were provided')
})

test_that('Track recommendation function can handle failed searches', {
  expect_true(is(getTrackRecommendations(seed_artists = 'gggggggg',
                                         seed_genres = 'jazz',
                                         seed_tracks = '0sCeNwt8xRCMR4NhKpMyBe'), 'NULL'))
  expect_true(is(getTrackRecommendations(seed_artists = 'herbie',
                                         seed_genres = 'gggggggg',
                                         seed_tracks = '0sCeNwt8xRCMR4NhKpMyBe'), 'list'))
  expect_true(is(getTrackRecommendations(seed_artists = 'herbie',
                                         seed_genres = 'jazz',
                                         seed_tracks = 'gggggggg'), 'NULL'))
})

test_that('Track recommendation function returns the correct dataframe', {
  expect_true(is(getTrackRecommendations(seed_artists = 'herbie',
                                         seed_genres = 'jazz',
                                         seed_tracks = '0sCeNwt8xRCMR4NhKpMyBe')[[1]], 'data.frame'))
})

test_that('Track recommendation function works with vector inputs', {
  expect_true(is(getTrackRecommendations(seed_artists = c('Ummet Ozcan', 'Robin Schulz'),
                                         seed_genres = c('electro house', 'progressive house'),
                                         seed_tracks = c('4l3FIRSFBFf3YQGH07FMAS'))[[1]], 'data.frame'))
})
