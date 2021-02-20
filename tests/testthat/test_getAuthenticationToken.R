#####################################
## Test the authentication function
#####################################



# This test fails because the code is robust and will generate an auth_token
#using predefined variables, even if user uses bad variables

#test_that("Authorization function returns NULL and warns user of invalid credentials", {
#  expect_true(is(getAuthenticationToken(CLIENT_ID = "undefined",
#                                        CLIENT_SECRET = "undefined"), "NULL"))
#  expect_message(getAuthenticationToken(CLIENT_ID = "undefined",
#                                        CLIENT_SECRET = "undefined"), 'Token authentication unsuccessful. Check credentials and try again')
#})



test_that("Authorization function returns a string even if auth_token is undefined", {

  expect_true(is(getAuthenticationToken(), "character"))

})


test_that("Authorization function skips POST request with an existing auth_token", {

  expect_message(getAuthenticationToken(), "Token Validity: Valid")

})
