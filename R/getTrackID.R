#' Retrieves track IDs users can select from a general string search query
#'
#' @param track The track to search for
#' @param limit Optional argument (default = 5) for the number of tracks to return (the greater the number the more likely you track appears in the dataframe)
#' @param authentication_token Predefined argument which runs getAuthenticationToken()
#'
#' @return Dataframe containing the track names, artist names, track IDs, and track popularity (0-100)
#' @export
#'
#' @examples
#' getTrackID('breeze blocks')
getTrackID <- function(track = NA, limit = 5, authentication_token = getAuthenticationToken()) {

  # Check if an input was provided
  if (is.na(track)) {
    message('No track string provided')
    return(NULL)
  }

  # Check if a token was defined
  if (exists('authentication_token') == FALSE) {
    message("Authorization token not defined.")
    return(NULL)
  }

  # Confirm input with user
  message(paste0("Searching track: ", track))

  # Format query url for the API
  track <- stringr::str_replace_all(track, ' ', '%20')
  url = glue::glue('https://api.spotify.com/v1/search?q={track}&type=track&limit={limit}')

  # Get a response and let the user know of the response status
  response <- httr::GET(url, httr::add_headers(Accept = 'application/json',
                        Authorization = paste('Bearer', authentication_token)))

  # Check if response was successful
  if (response$status != 200) {
    message("Search failed with response status: ", response$status)
    return(NULL)
  }

  content <- httr::content(response)
  content <- content$tracks$items

  # Let user know if any tracks were found
  if(length(content) == 0){
    message(glue::glue('No tracks found with input: {track}'))
    return(NULL)
  }

  # Parse content
  tracks_found <- data.frame('Track.Name' = '',
                             'Track.Artist' = '',
                             'Track.ID' = '',
                             'Track.Popularity' = '')

  for (item in 1:length(content)) {
    track_name <- content[[item]]$name
    track_artists <-  content[[item]]$artists
    track_id <- content[[item]]$id
    track_popularity <- content[[item]]$popularity

    # Often there are multiple artists so combine the artist names into a string
    artists <- ''
    for (artist in 1:length(track_artists)) {
      if (artist == 1) {
        artists <- glue::glue('{track_artists[[artist]]$name}')
      } else {
        artists <- glue::glue('{artists}, {track_artists[[artist]]$name}')
      }
    }

    # Except null returns by assigning them status 'Unknown'
    if (is.null(track_id) | class(track_id)=='try-error') {
      track_id <- 'Unknown'
    }

    # Continue appending rows to the dataframe
    tracks_found <- rbind(tracks_found, data.frame(
      'Track.Name' = track_name,
      'Track.Artist' = artists,
      'Track.ID' = track_id,
      'Track.Popularity' = track_popularity))
  }

  return(tracks_found)
}
