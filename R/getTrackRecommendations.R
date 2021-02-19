#' Track recommendation function based on seed artists, seed genres, and seed tracks
#'
#' @param seed_artists Required artist string or vector of comma separated artist strings
#' @param seed_genres Required genre string or vector of comma separated genre strings from spotify's available genre seeds
#' @param seed_tracks Required track ID as a string or vector of comma separated track IDs as strings
#' @param authentication_token Predefined argument which runs getAuthenticationToken()
#' @param limit Optional argument (default = 10) for the number of tracks to recommend
#' @param market Optional argument (default = NA) for the ISO 3166-1 alpha-2 country code or the string from auth_token
#' @param min_acousticness Optional argument (default = NA) ranges from (0-1)
#' @param max_acousticness Optional argument (default = NA) ranges from (0-1)
#' @param target_acousticness Optional argument (default = NA) ranges from (0-1)
#' @param min_danceability Optional argument (default = NA) ranges from (0-1)
#' @param max_danceability Optional argument (default = NA) ranges from (0-1)
#' @param target_danceability Optional argument (default = NA) ranges from (0-1)
#' @param min_duration_ms Optional argument (default = NA)
#' @param max_duration_ms Optional argument (default = NA)
#' @param target_duration_ms Optional argument (default = NA)
#' @param min_energy Optional argument (default = NA) ranges from (0-1)
#' @param max_energy Optional argument (default = NA) ranges from (0-1)
#' @param target_energy Optional argument (default = NA) ranges from (0-1)
#' @param min_instrumentalness Optional argument (default = NA) ranges from (0-1)
#' @param max_instrumentalness Optional argument (default = NA) ranges from (0-1)
#' @param target_instrumentalness Optional argument (default = NA) ranges from (0-1)
#' @param min_key Optional argument (default = NA)
#' @param max_key Optional argument (default = NA)
#' @param target_key Optional argument (default = NA)
#' @param min_liveness Optional argument (default = NA)
#' @param max_liveness Optional argument (default = NA)
#' @param target_liveness Optional argument (default = NA)
#' @param min_loudness Optional argument (default = NA)
#' @param max_loudness Optional argument (default = NA)
#' @param target_loudness Optional argument (default = NA)
#' @param min_mode Optional argument (default = NA)
#' @param max_mode Optional argument (default = NA)
#' @param target_mode Optional argument (default = NA)
#' @param min_popularity Optional argument (default = NA) ranges from (0-100)
#' @param max_popularity Optional argument (default = NA) ranges from (0-100)
#' @param target_popularity Optional argument (default = NA) ranges from (0-100)
#' @param min_speechiness Optional argument (default = NA) ranges from (0-1)
#' @param max_speechiness Optional argument (default = NA) ranges from (0-1)
#' @param target_speechiness Optional argument (default = NA) ranges from (0-1)
#' @param min_tempo Optional argument (default = NA)
#' @param max_tempo Optional argument (default = NA)
#' @param target_tempo Optional argument (default = NA)
#' @param min_time_signature Optional argument (default = NA)
#' @param max_time_signature Optional argument (default = NA)
#' @param target_time_signature Optional argument (default = NA)
#' @param min_valence Optional argument (default = NA) ranges from (0-1)
#' @param max_valence Optional argument (default = NA) ranges from (0-1)
#' @param target_valence Optional argument (default = NA) ranges from (0-1)
#'
#' @return A list containing 1) a dataframe with columns for track name, artist name, track id, track popularity, explicit status, and external track link, and 2) a pie chart summarizing the proportion of returned songs which are explicit.
#' @export
#'
#' @examples
#' First find song IDs using as an example: get_track_ID('sunday candy')
#' Then Input Artist, Genre, and track ID parameters to retrieve song recommendations
#' getTrackRecommendations(c('kanye west', 'chance the rapper', 'kendrick'), c('hip hop', 'rap'), '6fTdcGsjxlAD9PSkoPaLMX')
getTrackRecommendations <- function(seed_artists = NA, seed_genres = NA, seed_tracks = NA,
                                    authentication_token = getAuthenticationToken(),

                                    ## Optional bleow
                                    limit=NA, market=NA,
                                    min_acousticness=NA, max_acousticness=NA, target_acousticness=NA,
                                    min_danceability=NA, max_danceability=NA, target_danceability=NA,
                                    min_duration_ms=NA, max_duration_ms=NA, target_duration_ms=NA,
                                    min_energy=NA, max_energy=NA, target_energy=NA,
                                    min_instrumentalness=NA, max_instrumentalness=NA, target_instrumentalness=NA,
                                    min_key=NA, max_key=NA, target_key=NA,
                                    min_liveness=NA, max_liveness=NA, target_liveness=NA,
                                    min_loudness=NA, max_loudness=NA, target_loudness=NA,
                                    min_mode=NA, max_mode=NA, target_mode=NA,
                                    min_popularity=NA, max_popularity=NA, target_popularity=NA,
                                    min_speechiness=NA, max_speechiness=NA, target_speechiness=NA,
                                    min_tempo=NA, max_tempo=NA, target_tempo=NA,
                                    min_time_signature=NA, max_time_signature=NA, target_time_signature=NA,
                                    min_valence=NA, max_valence=NA, target_valence=NA) {
  # Check if an input was provided
  if (is.na(seed_artists) | is.na(seed_genres) | is.na(seed_tracks)) {
    message('Not all seeds were provided')
    return(NULL)
  }

  # Check if a token was defined
  if (exists('authentication_token') == FALSE) {
    message("Authorization token not defined.")
    return(NULL)
  }

  # Artist names need to be converted to a string of artist IDs
  artist_ids <- ''
  for (artist in 1:length(seed_artists)) {
    if (artist == 1) {
      id <- getArtistID(seed_artists[artist])[2]
      # Ensure artists are found so NULL arguments aren't passed forward
      if (is.null(id)) {
        message('No artist IDs found with the given seed_artists: ', seed_artists[artist])
        return(NULL)
      }
      artist_ids <- paste(id)
    } else {
      # Ensure artists are found so NULL arguments aren't passed forward
      if (is.null(id)) {
        message('No artist IDs found with the given seed_artists: ', seed_artists[artist])
        return(NULL)
      }
      id <- getArtistID(seed_artists[artist])[2]
      artist_ids <- glue::glue('{artist_ids}%2C{id}')
    }
  }

  seed_artists <- artist_ids

  # Genre names need to be converted to a string of genres
  genres_str <- ''
  for (genre in 1:length(seed_genres)) {
    clean <- stringr::str_replace_all(seed_genres[genre], ' ', '%20')
    if (genre == 1) {
      genres_str <- clean
    } else {
      genres_str <- glue::glue('{genres_str}%2C{clean}')
    }
  }

  seed_genres <- genres_str

  # Track IDs need to be converted to a string of tracks
  track_str <- ''
  for (track in 1:length(seed_tracks)) {
    clean <- stringr::str_replace_all(seed_tracks[track], ' ', '%20')
    if (track == 1) {
      track_str <- clean
    } else {
      track_str <- glue::glue('{track_str}%2C{clean}')
    }
  }

  seed_tracks <- track_str

  base_url = 'https://api.spotify.com/v1/recommendations'

  # Call the query assembler to combine and remove all unspecified values from arguments
  query = queryAssembler(seed_artists, seed_genres, seed_tracks, limit, market,
                         min_acousticness, max_acousticness, target_acousticness,
                         min_danceability, max_danceability, target_danceability,
                         min_duration_ms, max_duration_ms, target_duration_ms,
                         min_energy, max_energy, target_energy,
                         min_instrumentalness, max_instrumentalness, target_instrumentalness,
                         min_key, max_key, target_key,
                         min_liveness, max_liveness, target_liveness,
                         min_loudness, max_loudness, target_loudness,
                         min_mode, max_mode, target_mode,
                         min_popularity, max_popularity, target_popularity,
                         min_speechiness, max_speechiness, target_speechiness,
                         min_tempo, max_tempo, target_tempo,
                         min_time_signature, max_time_signature, target_time_signature,
                         min_valence, max_valence, target_valence)

  # Get a response and let the user know of the response status
  url = paste0(base_url, query)
  response <- httr::GET(url, httr::add_headers(Accept = 'application/json',
                        Authorization = paste('Bearer', authentication_token)))

  # Check if response was successful
  if (response$status != 200) {
    message("Search failed with response status: ", response$status)
    message("The request may either be invalid or simply returned no tracks from Spotify\nTry limiting some seeds to vectors of length 1.")
    return(NULL)
  }

  # Let user know if query returned no tracks
  content <- httr::content(response)
  content <- content$tracks
  if(length(content) == 0){
    message('No tracks were found\nPlease check the seed_genres and seed_tracks used')
    return(NULL)
  }

  # Data collection frame
  tracks_found <- data.frame('Track.Name' = '',
                             'Track.Artist' = '',
                             'Track.ID' = '',
                             'Track.Popularity' = '',
                             'Explicit.Status' = '',
                             'Track.Link' = '')

  for (item in 1:length(content)) {
    track_name <- content[[item]]$name
    artist_list <- content[[item]]$artists
    track_ID <- content[[item]]$id
    track_popularity <- content[[item]]$popularity
    track_explicit <- content[[item]]$explicit
    track_link <- content[[item]]$external_urls$spotify

    # Often there are multiple artists so combine the artist names into a string
    artists <- ''
    for(artist in 1:length(artist_list)){
      if(artist == 1){
        artists <- glue::glue('{artist_list[[artist]]$name}')
      } else {
        artists <- glue::glue('{artists}, {artist_list[[artist]]$name}')
      }
    }

    # Except null returns by assigning them status 'Unknown'
    if(is.null(track_ID) | class(track_ID)=='try-error') {
      track_ID <- 'Unknown'
    }

    # Continue appending rows to the dataframe
    tracks_found <- rbind(tracks_found,
                          data.frame(
                            'Track.Name' = track_name,
                            'Track.Artist' = artists,
                            'Track.ID' = track_ID,
                            'Track.Popularity' = track_popularity,
                            'Explicit.Status' = track_explicit,
                            'Track.Link' = track_link))
  }

  # Provide a data visualization metric for explicit content
  slices <- c(length(tracks_found[5][tracks_found[5] == TRUE]), length(tracks_found[5][tracks_found[5] == FALSE]))
  labs <- c(glue::glue('Explicit ({slices[1]})'), glue::glue('Clean ({slices[2]})'))
  pi <- pie(slices, labels = labs, main = 'Proportion of Returned Tracks\nwith Explicit Content')

  return(list(tracks_found, pi))
}


######################################
# 5 - Function: Query Assembler for API Call
######################################


#' Query assembler for the get_track_recommendation() function. This function wasn't designed for use by the user, only back-end processing for structuring the URL query.
#'
#' @param seed_artists Required artist string or vector of comma separated artist strings
#' @param seed_genres Required genre string or vector of comma separated genre strings from spotify's available genre seeds
#' @param seed_tracks Required track ID as a string or vector of comma separated track IDs as strings
#' @param authentication_token Predefined argument after running get_authentication_token()
#' @param limit Optional argument (default = 10) for the number of tracks to recommend
#' @param market Optional argument (default = NA) for the ISO 3166-1 alpha-2 country code or the string from auth_token
#' @param min_acousticness Optional argument (default = NA) ranges from (0-1)
#' @param max_acousticness Optional argument (default = NA) ranges from (0-1)
#' @param target_acousticness Optional argument (default = NA) ranges from (0-1)
#' @param min_danceability Optional argument (default = NA) ranges from (0-1)
#' @param max_danceability Optional argument (default = NA) ranges from (0-1)
#' @param target_danceability Optional argument (default = NA) ranges from (0-1)
#' @param min_duration_ms Optional argument (default = NA)
#' @param max_duration_ms Optional argument (default = NA)
#' @param target_duration_ms Optional argument (default = NA)
#' @param min_energy Optional argument (default = NA) ranges from (0-1)
#' @param max_energy Optional argument (default = NA) ranges from (0-1)
#' @param target_energy Optional argument (default = NA) ranges from (0-1)
#' @param min_instrumentalness Optional argument (default = NA) ranges from (0-1)
#' @param max_instrumentalness Optional argument (default = NA) ranges from (0-1)
#' @param target_instrumentalness Optional argument (default = NA) ranges from (0-1)
#' @param min_key Optional argument (default = NA)
#' @param max_key Optional argument (default = NA)
#' @param target_key Optional argument (default = NA)
#' @param min_liveness Optional argument (default = NA)
#' @param max_liveness Optional argument (default = NA)
#' @param target_liveness Optional argument (default = NA)
#' @param min_loudness Optional argument (default = NA)
#' @param max_loudness Optional argument (default = NA)
#' @param target_loudness Optional argument (default = NA)
#' @param min_mode Optional argument (default = NA)
#' @param max_mode Optional argument (default = NA)
#' @param target_mode Optional argument (default = NA)
#' @param min_popularity Optional argument (default = NA) ranges from (0-100)
#' @param max_popularity Optional argument (default = NA) ranges from (0-100)
#' @param target_popularity Optional argument (default = NA) ranges from (0-100)
#' @param min_speechiness Optional argument (default = NA) ranges from (0-1)
#' @param max_speechiness Optional argument (default = NA) ranges from (0-1)
#' @param target_speechiness Optional argument (default = NA) ranges from (0-1)
#' @param min_tempo Optional argument (default = NA)
#' @param max_tempo Optional argument (default = NA)
#' @param target_tempo Optional argument (default = NA)
#' @param min_time_signature Optional argument (default = NA)
#' @param max_time_signature Optional argument (default = NA)
#' @param target_time_signature Optional argument (default = NA)
#' @param min_valence Optional argument (default = NA) ranges from (0-1)
#' @param max_valence Optional argument (default = NA) ranges from (0-1)
#' @param target_valence Optional argument (default = NA) ranges from (0-1)
#'
#' @return A formatted string query to use in track recommendation API calls
#' @export
#'
queryAssembler <- function(seed_artists, seed_genres, seed_tracks, limit, market,
                           min_acousticness, max_acousticness, target_acousticness,
                           min_danceability, max_danceability, target_danceability,
                           min_duration_ms, max_duration_ms, target_duration_ms,
                           min_energy, max_energy, target_energy,
                           min_instrumentalness, max_instrumentalness, target_instrumentalness,
                           min_key, max_key, target_key,
                           min_liveness, max_liveness, target_liveness,
                           min_loudness, max_loudness, target_loudness,
                           min_mode, max_mode, target_mode,
                           min_popularity, max_popularity, target_popularity,
                           min_speechiness, max_speechiness, target_speechiness,
                           min_tempo, max_tempo, target_tempo,
                           min_time_signature, max_time_signature, target_time_signature,
                           min_valence, max_valence, target_valence) {

  # Capture all variables in a dataframe
  arguments <- data.frame(
    params = c('seed_artists', 'seed_genres', 'seed_tracks', 'limit', 'market',
               'min_acousticness', 'max_acousticness', 'target_acousticness',
               'min_danceability', 'max_danceability', 'target_danceability',
               'min_duration_ms', 'max_duration_ms', 'target_duration_ms',
               'min_energy', 'max_energy', 'target_energy',
               'min_instrumentalness', 'max_instrumentalness', 'target_instrumentalness',
               'min_key', 'max_key', 'target_key',
               'min_liveness', 'max_liveness', 'target_liveness',
               'min_loudness', 'max_loudness', 'target_loudness',
               'min_mode', 'max_mode', 'target_mode',
               'min_popularity', 'max_popularity', 'target_popularity',
               'min_speechiness', 'max_speechiness', 'target_speechiness',
               'min_tempo', 'max_tempo', 'target_tempo',
               'min_time_signature', 'max_time_signature', 'target_time_signature',
               'min_valence', 'max_valence', 'target_valence'),
    vals = c(seed_artists, seed_genres, seed_tracks, limit, market,
             min_acousticness, max_acousticness, target_acousticness,
             min_danceability, max_danceability, target_danceability,
             min_duration_ms, max_duration_ms, target_duration_ms,
             min_energy, max_energy, target_energy,
             min_instrumentalness, max_instrumentalness, target_instrumentalness,
             min_key, max_key, target_key,
             min_liveness, max_liveness, target_liveness,
             min_loudness, max_loudness, target_loudness,
             min_mode, max_mode, target_mode,
             min_popularity, max_popularity, target_popularity,
             min_speechiness, max_speechiness, target_speechiness,
             min_tempo, max_tempo, target_tempo,
             min_time_signature, max_time_signature, target_time_signature,
             min_valence, max_valence, target_valence))

  # Unspecified arguments need to be removed
  specified_args <- na.omit(arguments)

  # Format the specified arguments into Spotify call structure
  # Structure: 'var' --> 'var={var}&'
  formatted_args <- NA
  for (i in 1:nrow(specified_args)) {
    if (i==1) {
      formatted_args[[i]] <- glue::glue('?{specified_args[i,1]}={specified_args[i,2]}')
    } else {
      formatted_args[[i]] <- glue::glue('&{specified_args[i,1]}={specified_args[i,2]}')
    }
  }

  # Formatted arguments must be concatenated into a string
  assembled_query <- do.call(paste, c(as.list(formatted_args), sep = ""))

  return (assembled_query)
}
