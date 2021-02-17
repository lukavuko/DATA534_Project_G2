source("R/EricsFunctions.R")

library(testthat)


client_id <-  Sys.getenv('CLIENT_ID')
client_secret_id <-  Sys.getenv('CLIENT_SECRET_ID')
get_authentication_token(client_id, client_secret_id)


# Test getArtist

ghost <-
  getArtistInfo("1Qp56T7n950O3EGMsSl81D", dataframe = TRUE)
ghost2 <-
  getArtistInfo(
    "Ghost",
    byName = TRUE,
    dataframe = T,
    lim = 7
  )
Hu <-
  getArtistInfo("0b2B3PwcYzQAhuJacmcYgc", dataframe = TRUE)

test_that("Gets correct artists", {
  expect_match(ghost$name, "Ghost")
  expect_match(Hu$name, "The HU")
  expect_equal(nrow(ghost2), 7)
})


# Test getSongInfo

totem <-
  getSongInfo("5hISmTJXBXdOes4htbUhGk", dataframe = TRUE)
dance <-
  getSongInfo("1E2WTcYLP1dFe1tiGDwRmT", dataframe = T)
motormouth <-
  getSongInfo(
    "Motormouth",
    byName = T,
    dataframe = T,
    lim = 14
  )

test_that("Gets correct song", {
  expect_match(totem$trackName, "Wolf Totem")
  expect_match(dance$trackName, "Dance Macabre")
  expect_equal(nrow(motormouth), 14)
  expect_error(getSongInfo("5hISmTJXBXdOes4htbUhGk", authentication_token = "BADTOKEN"), "401 : Invalid access token")
})

# Test getRelatedArtists

suicide <-
  getRelatedArtists("6HZr7Fs2VfV1PYHIwo8Ylc", dataframe = T)
ghost <-
  getRelatedArtists("1Qp56T7n950O3EGMsSl81D", dataframe = T)


test_that("Check related artists", {
  expect_match(suicide$name[1], "Chelsea Grin")
  expect_match(ghost$name[1], "Mastodon")
  expect_error(getRelatedArtists("BADINPUT") , "400 : invalid id")
})


# Test getTopSongs

grandson <-
  getTopSongs("4ZgQDCtRqZlhLswVS6MHN4", output = "dataframe")
giraffe <-
  getTopSongs("1yqs45BSh7457Flyhmdv7f", output = "dataframe")

test_that("Check top songs", {
  expect_match(grandson$song[1], "Blood // Water")
  expect_match(giraffe$song[1], "Honeybee")
})

