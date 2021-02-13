library(tidyverse)
library(jsonlite)
library(httr)
library(glue)
library(stringr)

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
  return (authentication_token)
}  
  
getArtistInfo <- function(authentication_token, artist, byName = FALSE, dataframe = TRUE, lim = 10){
  if (byName == FALSE){
    url <- "https://api.spotify.com/v1/artists/"
    query <- artist
    response <- GET(paste0(url, query), 
                    add_headers(Accept = "application/json", 
                                Authorization = paste("Bearer", authentication_token)))
    content <- content(response)
    
    if(response$status_code != 200){
      stop(paste(response$status_code,":", content$error$message))
    }
    
    if (dataframe == TRUE){
      # The dataframe can only handle 1 genre, but the requst returns a list.
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


getSongInfo <- function(authentication_token, song, byName = FALSE, dataframe = TRUE, lim = 10){
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


getRelatedArtists <- function(authentication_token, artistId, dataframe =  TRUE){
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


getTopSongs <- function(authentication_token, artistId, dataframe =  TRUE, region = "CA"){
  url <- glue("https://api.spotify.com/v1/artists/{artistId}/top-tracks?market={region}")
  response <- GET(url, add_headers(Accept = "application/json", 
                                   Authorization = paste("Bearer", authentication_token)))
  content <- content(response)
  
  if(response$status_code != 200){
    stop(paste(response$status_code,":", content$error$message))
  }
  
  if(dataframe == TRUE){
    df <- data.frame(song = character(), id = character())
    
    for (i in 1:length(content$tracks)){
      row <- data.frame(song = content$tracks[[i]]$name,
                        id = content$tracks[[i]]$id)
      df <- rbind(df, row)
    }
    return(df)
  }
  else{
    return(content)
  }
}