#############################
## Test getArtist
#############################

test_that("Gets correct artists", {
  expect_match(getArtistInfo("1Qp56T7n950O3EGMsSl81D", dataframe = TRUE)$name, "Ghost")
  expect_match(getArtistInfo("0b2B3PwcYzQAhuJacmcYgc", dataframe = TRUE)$name, "The HU")
  expect_equal(nrow(getArtistInfo("Ghost", byName = TRUE, dataframe = T, lim = 7)), 7)
  expect_error(getArtistInfo("BADINPUT") , "400 : invalid id")
  expect_error(getArtistInfo("1Qp56T7n950O3EGMsSl81D", authentication_token = "BADTOKEN"), "401 : Invalid access token")
})


# Test getSongInfo

test_that("Gets correct song", {
  expect_match(getSongInfo("5hISmTJXBXdOes4htbUhGk", dataframe = TRUE)$trackName, "Wolf Totem")
  expect_match(getSongInfo("1E2WTcYLP1dFe1tiGDwRmT", dataframe = T)$trackName, "Dance Macabre")
  expect_equal(nrow(getSongInfo("Motormouth", byName = T, dataframe = T, lim = 14)), 14)
  expect_error(getSongInfo("5hISmTJXBXdOes4htbUhGk", authentication_token = "BADTOKEN"), "401 : Invalid access token")
  expect_error(getSongInfo("BADINPUT") , "400 : invalid id")
})

# Test getRelatedArtists

test_that("Check related artists", {
  expect_match(getRelatedArtists("6HZr7Fs2VfV1PYHIwo8Ylc", dataframe = T)$name[1], "Chelsea Grin")
  expect_match(getRelatedArtists("1Qp56T7n950O3EGMsSl81D", dataframe = T)$name[1], "Mastodon")
  expect_error(getRelatedArtists("BADINPUT") , "400 : invalid id")
  expect_error(getRelatedArtists("1Qp56T7n950O3EGMsSl81D", authentication_token = "BADTOKEN"), "401 : Invalid access token")
})


# Test getTopSongs

test_that("Check top songs", {
  expect_match(getTopSongs("4ZgQDCtRqZlhLswVS6MHN4", output = "dataframe")$song[1], "Blood // Water")
  expect_match(getTopSongs("1yqs45BSh7457Flyhmdv7f", output = "dataframe")$song[1], "Honeybee")
  expect_error(getTopSongs("BADINPUT") , "400 : invalid id")
  expect_error(getTopSongs("1Qp56T7n950O3EGMsSl81D", authentication_token = "BADTOKEN"), "401 : Invalid access token")
})


# Test getAudioFeatures

test_that("Check Audio Features", {
  expect_error(getAudioFeatures("5hISmTJXBXdOes4htbUhGk", authentication_token = "BADTOKEN"), "401 : Invalid access token")
  expect_error(getAudioFeatures("BADINPUT") , "400 : invalid request")
  expect_equal(getAudioFeatures("3Vok4b8G2Yak5vaHOqKipV", output = "json")$valence, 0.355)
  expect_equal(getAudioFeatures("68ngtC3pGiTjXcFwxYCJ7Z", output = "json")$tempo, 121.016)

})
