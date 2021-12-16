#####################################
## Testing the Track to ID converter
#####################################

test_that('Track ID converter can handle missing track arguments', {
  expect_true(is(getTrackID(), 'NULL'))
  expect_message(getTrackID(), 'No track string provided.')
})

test_that('Track ID converter can handle failed searches', {
  expect_true(is(getTrackID(''), 'NULL'))
  expect_message(getTrackID(''), 'Search failed with response status: 404')
})

# This test doesn't work in CI
#test_that('Track ID converter returns the correct dataframe', {
#  expect_true(is(getTrackID('cantaloupe island'), 'data.frame'))
#  expect_true('Cantaloupe Island' %in% getTrackID('cantaloupe island')$Track.Name)
#})
