source("EricsFunctions.R", chdir = TRUE)

library(testthat)


client_id <-  Sys.getenv('CLIENT_ID')
client_secret_id <-  Sys.getenv('CLIENT_SECRET_ID')
authentication_token <-
  get_authentication_token(client_id, client_secret_id)


# Test getArtist

ghost <-
  getArtistInfo(authentication_token, "1Qp56T7n950O3EGMsSl81D", dataframe = TRUE)
ghost2 <-
  getArtistInfo(
    authentication_token,
    "Ghost",
    byName = TRUE,
    dataframe = T,
    lim = 7
  )
Hu <-
  getArtistInfo(authentication_token, "0b2B3PwcYzQAhuJacmcYgc", dataframe = TRUE)

test_that("Gets correct artists", {
  expect_match(ghost$name, "Ghost")
  expect_match(Hu$name, "The HU")
  expect_equal(nrow(ghost2), 7)
})


# Test getSongInfo

totem <-
  getSongInfo(authentication_token, "5hISmTJXBXdOes4htbUhGk", dataframe = TRUE)
dance <-
  getSongInfo(authentication_token, "1E2WTcYLP1dFe1tiGDwRmT", dataframe = T)
motormouth <-
  getSongInfo(
    authentication_token,
    "Motormouth",
    byName = T,
    dataframe = T,
    lim = 14
  )

test_that("Gets correct song", {
  expect_match(totem$trackName, "Wolf Totem")
  expect_match(dance$trackName, "Dance Macabre")
  expect_equal(nrow(motormouth), 14)
})

# Test getRelatedArtists

suicide <-
  getRelatedArtists(authentication_token, "6HZr7Fs2VfV1PYHIwo8Ylc", dataframe = T)
ghost <-
  getRelatedArtists(authentication_token, "1Qp56T7n950O3EGMsSl81D", dataframe = T)

test_that("Check related artists", {
  expect_match(suicide$name[1], "Chelsea Grin")
  expect_match(ghost$name[1], "Mastodon")
})


# Test getTopSongs

grandson <-
  getTopSongs(authentication_token, "4ZgQDCtRqZlhLswVS6MHN4", dataframe = T)
giraffe <-
  getTopSongs(authentication_token, "1yqs45BSh7457Flyhmdv7f", dataframe = T)

test_that("Check top songs", {
  expect_match(grandson$song[1], "Blood // Water")
  expect_match(giraffe$song[1], "Honeybee")
})

