#####################################
# Testing the Artist to ID converter
#####################################

test_that('Artist ID converter can handle missing artist arguments', {
  expect_true(is(getArtistID(), 'NULL'))
  expect_message(getArtistID(), 'No artist string provided.')
})

test_that('Artist ID converter can handle failed searches', {
  expect_true(is(getArtistID(''), 'NULL'))
})

test_that('Artist ID converter returns the correct dataframe', {
  expect_true(is(getArtistID('martin garex'), 'data.frame'))
  expect_true(getArtistID('martin garex')[3] > 50)
  expect_true(getArtistID('martin garex')[1] == 'Martin Garrix')
})
