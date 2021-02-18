library(tidyverse)
library(jsonlite)
library(httr)
library(glue)
library(stringr)
library(roxygen2)
library(devtools)


#' Get an Authentication Token for the Spotify API
#'
#'Queries the API for a token and sets the token as a global variable
#'
#'A token will only remain valid for a few hours. If the package gives 401 errors, rerun this function.
#'
#' @param client_id Your client id. Can be found at https://developer.spotify.com/dashboard

#' @param client_secret_id Similar to client id
#'
#' @return an authentication token, saved to global environments as auth_token
#'
#' @examples
#' get_authentication_token(client_id, client_secret_id)
#'
#' @export
get_authentication_token <- function(client_id, client_secret_id) {
  response = POST(
    'https://accounts.spotify.com/api/token',
    accept_json(),
    authenticate(client_id, client_secret_id),
    body = list(grant_type = 'client_credentials'),
    encode = 'form',
    verbose()
  )
  authentication_token = content(response)$access_token
  auth_token <<- authentication_token
  return(auth_token)
}

#' Get Data on a Spotify Artist
#'
#' Search using either an artists name or Spotify id code.
#'
#' @param artist The id or name of a Spotify artist to search.
#' @param byName Boolean. TRUE searches artist by name, FALSE searches by id.
#' @param dataframe Boolean. TRUE returns data cleaned in a dataframe, FALSE returns raw json.
#' @param lim The number of results to return if searched by name.
#' @param authentication_token The users authentication token. Defaults to the value returned by get_authentication_token.
#'
#' @return A dataframe or json object containing an artists information.
#' @export
#'
#' @examples
#' getArtistInfo("Ghost", byName = TRUE, dataframe = TRUE)
#'
getArtistInfo <- function(artist, byName = FALSE, dataframe = TRUE, lim = 10, authentication_token = auth_token){
  # This runs if the user searches a specific Id, and the API can pull one artist knowing
  # it is the intended one.
  if (byName == FALSE){
    url <- "https://api.spotify.com/v1/artists/"
    query <- artist
    response <- GET(paste0(url, query),
                    add_headers(Accept = "application/json",
                                Authorization = paste("Bearer", authentication_token)))
    content <- content(response)

    # Ensure the response code indicates success. If not return the error
    if(response$status_code != 200){
      stop(paste(response$status_code,":", content$error$message))
    }

    if (dataframe == TRUE){
      # The dataframe can only handle 1 genre, but the request returns a list.
      # We only take the top genre, and if there are none, we set it as unknown.
      if(length(content$genres) != 0){
        genre <- content$genres[[1]]
      }
      else{
        genre <- "Unknown"
      }

      df <- data.frame(name  = content$name, popularity = content$popularity,
                       genres = genre, followers = content$followers$total, id = content$id)
      return(df)
    }

    else{
      return(content)
    }
  }
  # Run this if user searches by name. The function returns a list of the top matches.
  if (byName == TRUE){
    url <- glue('https://api.spotify.com/v1/search?q={artist}&type=artist&limit={lim}')
    response <- GET(url, add_headers(q = artist, type = "artist", Accept = "application/json",
                                     Authorization = paste("Bearer", authentication_token)))
    content <- content(response)

    if(response$status_code != 200){
      stop(paste(response$status_code,":", content$error$message))
    }

    if (dataframe == TRUE){
      df <- data.frame(name = character(),
                       popularity = integer(),
                       genres = character(),
                       followers = integer(),
                       id = character())
      for (i in 1:length(content$artists$items)){


        if(length(content$artists$items[[i]]$genres) != 0){
          genre <- content$artists$items[[i]]$genres[[1]]
        }
        else{
          genre <- "Unknown"
        }

        row <- data.frame(name = content$artists$items[[i]]$name[1],
                          popularity = content$artists$items[[i]]$popularity,
                          genres =genre,
                          followers = content$artists$items[[i]]$followers$total,
                          id = content$artists$items[[i]]$id)
        df <- rbind(df, row)
      }
      return(df)
    }
    else{
      return(content)
    }
  }
}


#' Get data on a song using Spotify API
#'
#' Search using either a songs name or Spotify id code.
#'
#' @param song The name or id of a song to search for.
#' @param byName Boolean. TRUE searches by name, FALSE searches by id.
#' @param dataframe Boolean. TRUE returns data in a dataframe, FALSE returns raw JSON object.
#' @param lim The number of results to return if searched by name.
#' @param authentication_token The users authentication token. Defaults to the value returned by get_authentication_token.
#'
#' @return A dataframe or json object of song information.
#' @export
#'
#' @examples
#' getSongInfo(")
#'
getSongInfo <- function(song, byName = FALSE, dataframe = TRUE, lim = 10, authentication_token = auth_token){
  # User searches by song Id, and teh function returns info on that specific song
  if(byName == FALSE){
    url <- "https://api.spotify.com/v1/tracks/"
    query <- song
    response <- GET(paste0(url, query),
                    add_headers(Accept = "application/json",
                                Authorization = paste("Bearer", authentication_token)))
    content <- content(response)

    if(response$status_code != 200){
      stop(paste(response$status_code,":", content$error$message))
    }

    if (dataframe == TRUE){
      df <- data.frame(artist = content$artists[[1]]$name, album  = content$album$name,
                       trackName = content$name, release_date = content$album$release_date,
                       popularity = content$popularity, duration = content$duration,
                       id = content$id)
      return(df)
    }
    else{
      return(content)
    }
  }

  else{
    # User searches by name, so the function returns a list of matches
    url <- glue("https://api.spotify.com/v1/search?q={song}&type=track&limit={lim}")
    response <- GET(url, add_headers(q = song, type = "track", Accept = "application/json",
                                     Authorization = paste("Bearer", authentication_token)))
    content <- content(response)

    if(response$status_code != 200){
      stop(paste(response$status_code,":", content$error$message))
    }

    if(dataframe == TRUE){
      df <- data.frame(artist = character(), album  = character(),
                       trackName = character(), release_date = character(),
                       popularity = integer(), duration = integer(),
                       id = character())
      for(i in 1:length(content$tracks$items)){
        entry <- content$tracks$items[[i]]
        row <- data.frame(artist = entry$artists[[1]]$name,
                          album = entry$album$name,
                          trackName = entry$name,
                          release_date = entry$album$release_date,
                          popularity = entry$popularity,
                          duration = entry$duration_ms,
                          id = entry$id)
        df <- rbind(df, row)
      }
      return(df)
    }
    else{
      return(content)
    }
  }
}


#' Get an Artists Related Artists
#'
#' @param artistId The Spotify ID of an artist.
#' @param dataframe Boolean. TRUE returns data in a cleaned dataframe, FALSE returns raw JSON object.
#' @param authentication_token The users authentication token. Defaults to the value returned by get_authentication_token.
#'
#' @return Ten artists related to the speccified artist.
#' @export
#'
#' @examples
#' getRelatedArtists(artistId = "1Qp56T7n950O3EGMsSl81D", dataframe = TRUE)
#'
getRelatedArtists <- function(artistId, dataframe =  TRUE, authentication_token = auth_token){
  url <- glue("https://api.spotify.com/v1/artists/{artistId}/related-artists")
  response <- GET(url, add_headers(Accept = "application/json",
                                   Authorization = paste("Bearer", authentication_token)))
  content <- content(response)

  if(response$status_code != 200){
    stop(paste(response$status_code,":", content$error$message))
  }

  if(dataframe == TRUE){
    df <- data.frame(artist = character(), id = character())

    for (i in 1:length(content$artists)){
      row <- data.frame(name = content$artists[[i]]$name,
                        id = content$artists[[i]]$id)
      df <- rbind(df, row)
    }
    return(df)
  }
  else{
    return(content)
  }
}


#' Get an Artists Top Songs on Spotify
#'
#' @param artistId The Spotify ID of an artist.
#' @param output How to output data. acceptable values are "json", "dataframe", or "graph".
#' @param region The two letter code of the market region to check. Default is "CA" for Canada.
#' @param authentication_token The users authentication token. Defaults to the value returned by get_authentication_token.
#'
#' @return An object of chosen type containing info on an artists top songs.
#' @export
#'
#' @examples
#' getTopSongs("3WPKDlucMsXH6FC1XaclZC", output = "dataframe", region = "CA")
getTopSongs <- function(artistId, output =  "dataframe", region = "CA", authentication_token = auth_token){
  if (output != "json" & output != "dataframe" & output != "graph"){
    stop("output parameter must be one of json, dataframe, graph")
  }
  url <- glue("https://api.spotify.com/v1/artists/{artistId}/top-tracks?market={region}")
  response <- GET(url, add_headers(Accept = "application/json",
                                   Authorization = paste("Bearer", authentication_token)))
  content <- content(response)

  if(response$status_code != 200){
    stop(paste(response$status_code,":", content$error$message))
  }

  if(output != "json"){
    df <- data.frame(song = character(), id = character(), popularity = integer(), duration_mins = integer())

    for (i in 1:length(content$tracks)){
      row <- data.frame(song = content$tracks[[i]]$name,
                        id = content$tracks[[i]]$id,
                        popularity = content$tracks[[i]]$popularity,
                        duration_mins = content$tracks[[i]]$duration_ms / 60000)
      df <- rbind(df, row)
    }

    if (output == "dataframe"){
      return(df)
    }

    # Only output left is 'graph'
    else{
      plot <- df %>% ggplot(aes(x = popularity, y = reorder(song, popularity))) +
        geom_bar(stat = "identity",  fill = "blue") +
        ggtitle(paste0(content$tracks[[1]]$artists[[1]]$name, "'s Most Popular Tracks"))+
        ylab("Song Name")+
        xlab("Popularity") +
        xlim(c(0,100))
      return(plot)
    }
  }
  else{ # User requested json
    return(content)
  }
}

# Get Audio Features

getAudioFeatures <- function(songId, output =  "dataframe", authentication_token = auth_token){
  if (output != "json" & output != "dataframe" & output != "graph"){
    stop("output parameter must be one of json, dataframe, graph")
  }
  url <- glue("https://api.spotify.com/v1/audio-features/{songId}")
  response <- GET(url, add_headers(Accept = "application/json",
                                   Authorization = paste("Bearer", authentication_token)))
  content <- content(response)

  if(response$status_code != 200){
    stop(paste(response$status_code,":", content$error$message))
  }

  if(output != "json"){
    songname <- getSongInfo(songId, dataframe = TRUE)$trackName
    df <- data.frame(metric = c("danceability", "energy", "speechiness", "acousticness",
                                "instrumentalness", "liveness", "valence", "tempo", "time_signature",
                                "duration_ms", "loudness"),
                     value = c(content$danceability, content$energy, content$speechiness,
                               content$acousticness, content$instrumentalness, content$liveness, content$valence,
                               content$tempo, content$time_signature, content$duration_ms, content$loudness))

    if (output == "dataframe"){
      return(df)
    }

    # Only output left is 'graph'
    else{
      plot <- df %>% head(7) %>% ggplot(aes(y = metric, x = value)) +
        geom_point(fill = "blue") +
        ggtitle(paste0(songname, "'s Metrics"))+
        ylab("Song Metric")+
        xlab("Value") +
        xlim(c(0,1))
      return(plot)
    }
  }
  else{ # User requested json
    return(content)
  }
}
