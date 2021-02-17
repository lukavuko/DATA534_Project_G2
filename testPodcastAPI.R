source('R/spotifyPodcastAPI.R')

library(testthat)

client_id = Sys.getenv('CLIENT_ID')
client_secret_id = Sys.getenv('CLIENT_SECRET_ID')

