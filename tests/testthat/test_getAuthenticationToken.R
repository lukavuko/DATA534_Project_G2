#####################################
## Test the authentication function
#####################################

test_that("Authorization function returns NULL and warns user of invalid credentials", {
  expect_true(is(getAuthenticationToken(CLIENT_ID = "undefined",
                                        CLIENT_SECRET = "undefined"), "NULL"))
  expect_message(getAuthenticationToken(CLIENT_ID = "undefined",
                                        CLIENT_SECRET = "undefined"), 'Token authentication unsuccessful. Check credentials and try again')
})

test_that("Authorization function returns a string", {
  expect_true(is(getAuthenticationToken(), "character"))
})

# Error handling was incorporated so no error should be expected
#test_that('A test to check if an error is raised on entering an invalid client or secret ID', {
#  expect_error(getAuthenticationToken('abcd',1))
#  expect_error(getAuthenticationToken('abcd','abcd'))
#})
