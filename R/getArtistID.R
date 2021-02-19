######################################
# 2 - Function: Artist to ID converter
######################################

#source('R/getAuthenticationToken.R')

#' Retrieves an artist ID from a general name search query
#'
#' @param artist The artist to search for as a string
#' @param authentication_token Predefined argument which runs getAuthenticationToken()
#'
#' @return Dataframe containing the artist name, ID, popularity, and related genres
#' @export
#'
#' @examples
#' getArtistID('alt j')
getArtistID <- function (artist = NA, authentication_token = getAuthenticationToken()) {

  # Check if an input was provided
  if (is.na(artist)) {
    message('No artist string provided')
    return(NULL)
  }

  # Check if a token was defined
  if (exists('authentication_token') == FALSE) {
    message("Authorization token not defined.")
    return(NULL)
  }

  # Confirm input with user
  message(paste0("Searching artist: ", artist))

  # Format query url for the API
  artist <- stringr::str_replace_all(artist, ' ', '%20')
  url = glue::glue('https://api.spotify.com/v1/search?q={artist}&type=artist&limit=1')

  # Get a response and let the user know of the response status
  response <- httr::GET(url, httr::add_headers(Accept = 'application/json',
                        Authorization = paste('Bearer', authentication_token)))

  # Check if response was successful
  if (response$status != 200) {
    message("Search failed with response status: ", response$status)
    return(NULL)
  }

  # Check if any artist was found
  if (httr::content(response)$artists$total == 0) {
    message(glue::glue('No artists found with input: {artist}'))
    return(NULL)
  }

  content <- httr::content(response)
  content <- content$artists$items[[1]]

  # Parse content
  artist_name <- content$name
  artist_id <- content$id
  artist_popularity <- content$popularity
  artist_genres <- paste(unlist(content$genres), collapse = ', ')

  # Check that an artist id was returned
  if (is.null(artist_id) | class(artist_id)=='try-error') {
    artist_id <- 'Unknown'
    message("Artist ID: ", artist_id)
    return(NULL)
  }

  # Message if artist search was successful
  message(paste("Artist Found: ", artist_name))

  return(data.frame(
    'Artist.name' = c(artist_name),
    'Artist.ID' = c(artist_id),
    'Artist.Popularity' = c(artist_popularity),
    'Genres' = c(artist_genres)))
}
