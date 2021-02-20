#' Get Data on a Spotify Artist
#'
#' Search using either an artists name or Spotify id code.
#'
#' @param artist The id or name of a Spotify artist to search.
#' @param byName Boolean. TRUE searches artist by name, FALSE searches by id.
#' @param dataframe Boolean. TRUE returns data cleaned in a dataframe, FALSE returns raw json.
#' @param lim The number of results to return if searched by name.
#' @param authentication_token Predefined argument which runs getAuthenticationToken()
#'
#' @return A dataframe or json object containing an artists information.
#' @export
#'
#' @examples
#' getArtistInfo("Ghost", byName = TRUE, dataframe = TRUE)
getArtistInfo <- function(artist, byName = FALSE, dataframe = TRUE, lim = 10, authentication_token = getAuthenticationToken()){
  # This runs if the user searches a specific Id, and the API can pull one artist knowing
  # it is the intended one.
  if (byName == FALSE){
    url <- "https://api.spotify.com/v1/artists/"
    query <- artist
    response <- httr::GET(paste0(url, query),
                          httr::add_headers(Accept = "application/json",
                                Authorization = paste("Bearer", authentication_token)))

    content <- httr::content(response)

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
    url <- glue::glue('https://api.spotify.com/v1/search?q={artist}&type=artist&limit={lim}')
    response <- httr::GET(url, httr::add_headers(q = artist, type = "artist", Accept = "application/json",
                                     Authorization = paste("Bearer", authentication_token)))
    content <- httr::content(response)

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
#' @param authentication_token Predefined argument which runs getAuthenticationToken()
#'
#'
#' @return A dataframe or json object of song information.
#' @export
#'
#' @examples
#' getSongInfo("Motormouth", byName = TRUE)
getSongInfo <- function(song, byName = FALSE, dataframe = TRUE, lim = 10, authentication_token = getAuthenticationToken()){
  # User searches by song Id, and teh function returns info on that specific song
  if(byName == FALSE){
    url <- "https://api.spotify.com/v1/tracks/"
    query <- song
    response <- httr::GET(paste0(url, query),
                          httr::add_headers(Accept = "application/json",
                                Authorization = paste("Bearer", authentication_token)))
    content <- httr::content(response)

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
    url <- glue::glue("https://api.spotify.com/v1/search?q={song}&type=track&limit={lim}")
    response <- httr::GET(url, httr::add_headers(q = song, type = "track", Accept = "application/json",
                                     Authorization = paste("Bearer", authentication_token)))
    content <- httr::content(response)

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
#' @param authentication_token Predefined argument which runs getAuthenticationToken()
#'
#'
#' @return Ten artists related to the speccified artist.
#' @export
#'
#' @examples
#' getRelatedArtists(artistId = "1Qp56T7n950O3EGMsSl81D", dataframe = TRUE)
getRelatedArtists <- function(artistId, dataframe =  TRUE, authentication_token = getAuthenticationToken()){
  url <- glue::glue("https://api.spotify.com/v1/artists/{artistId}/related-artists")
  response <- httr::GET(url, httr::add_headers(Accept = "application/json",
                                   Authorization = paste("Bearer", authentication_token)))
  content <- httr::content(response)

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
#' @param authentication_token Predefined argument which runs getAuthenticationToken()
#'
#'
#' @return An object of chosen type containing info on an artists top songs.
#' @export
#'
#' @examples
#' getTopSongs("3WPKDlucMsXH6FC1XaclZC", output = "dataframe", region = "CA")
getTopSongs <- function(artistId, output =  "dataframe", region = "CA", authentication_token = getAuthenticationToken()){

  if (output != "json" & output != "dataframe" & output != "graph") {
    stop("output parameter must be one of json, dataframe, graph")
  }
  url <- glue::glue("https://api.spotify.com/v1/artists/{artistId}/top-tracks?market={region}")

  response <- httr::GET(url, httr::add_headers(Accept = "application/json",
                                   Authorization = paste("Bearer", authentication_token)))

  content <- httr::content(response)

  if (response$status_code != 200) {
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
      plot <- ggplot2::ggplot(df, ggplot2::aes(x = popularity, y = stats::reorder(song, popularity))) +
        ggplot2::geom_bar(stat = "identity",  fill = "blue") +
        ggplot2::ggtitle(paste0(content$tracks[[1]]$artists[[1]]$name, "'s Most Popular Tracks"))+
        ggplot2::ylab("Song Name")+
        ggplot2::xlab("Popularity") +
        ggplot2::xlim(c(0,100))
      return(plot)
    }
  }
  else{ # User requested json
    return(content)
  }
}

# Get Audio Features

#' Get Audio Features of a Song
#'
#' Spotify automatically generates a number of audio features for each song.
#'
#' @param songId The Id of a song to search
#' @param output Output type. "json", "dataframe", or "graph"
#' @param authentication_token Predefined argument which runs getAuthenticationToken()
#'
#'
#' @return A json object, dataframe, or graph describing song features
#' @export
#'
#' @examples
getAudioFeatures <- function(songId, output =  "dataframe", authentication_token = getAuthenticationToken()){

  if (output %in% c("json", "dataframe", "graph") == FALSE) {
    stop("output parameter must be one of json, dataframe, graph")
  }

  url <- glue::glue("https://api.spotify.com/v1/audio-features/{songId}")

  response <- httr::GET(url, httr::add_headers(Accept = "application/json",
                                   Authorization = paste("Bearer", authentication_token)))
  content <- httr::content(response)

  if (response$status_code != 200) {
    stop(paste(response$status_code,":", content$error$message))
  }

  # Sometimes the Spotify API will just return an empty list on a valid call, and just
  # running the function again th same way will make it work.
  if (length(content) < 6){
    stop("Something unexpected went wrong. Please try again.")
  }

  if (output != "json") {
    songname <- getSongInfo(songId, dataframe = TRUE)$trackName
    df <- data.frame(metric = c("danceability", "energy", "speechiness", "acousticness",
                                "instrumentalness", "liveness", "valence", "tempo", "time_signature",
                                "duration_ms", "loudness"),
                     value = c(content$danceability, content$energy, content$speechiness,
                               content$acousticness, content$instrumentalness, content$liveness, content$valence,
                               content$tempo, content$time_signature, content$duration_ms, content$loudness))

    if (output == "dataframe") {
      return(df)
    }

    # Only output left is 'graph'
    else {
      plot <- ggplot2::ggplot(df, ggplot2::aes(y = metric, x = value)) +
        ggplot2::geom_point(fill = "blue") +
        ggplot2::ggtitle(paste0(songname, "'s Metrics"))+
        ggplot2::ylab("Song Metric")+
        ggplot2::xlab("Value") +
        ggplot2::xlim(c(0,1))
      return(plot)
    }
  } else { # User requested json
    return(content)
  }
}
