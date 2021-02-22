#' Get Show ID
#'
#' Retrieves a podcast ID from a general name search query
#'
#' @param query string: The show to search for
#' @param market string: (optional, defaults to US) A string returning shows that are available in that market
#' @param authentication_token Predefined argument which runs getAuthenticationToken()
#'
#' @return A string containing the show's ID
#' @export
#'
#' @examples
#' getPodcastID('Philosophize This!', market='US')
#' getPodcastID('Philosophize This!')
getPodcastID <- function(query, market='US', authentication_token = getAuthenticationToken()){


  if (is.character(market)==TRUE & nchar(market)!=2) {
    stop('Only ISO 3166-1 alpha-2 country codes are accepted at the moment!')
  }

  if (is.character(market)==FALSE) {
    stop('Please enter an ISO 3166-1 alpha-2 country code!')
  }

  base_url = 'https://api.spotify.com/v1/search'
  response <- httr::GET(base_url,
                    query = list(q = enc2utf8(query),
                               type = 'show',
                               market=market),
                    httr::add_headers(Accept = 'application/json',
                              Authorization = paste('Bearer', authentication_token)))

  content <- httr::content(response)

  # If the content returned is atomic, simply re-query the api
  # for a recursive type vector. (Spotify sometimes fails to return data)
  if (is.atomic(content) == TRUE) {
    response <- httr::GET(base_url,
                          query = list(q = enc2utf8(query),
                                       type = 'show',
                                       market=market),
                          httr::add_headers(Accept = 'application/json',
                                            Authorization = paste('Bearer', authentication_token)))
    content <- httr::content(response)
    if (is.atomic(content) == TRUE) {
      message('Returned content is atomic. Querying was unsuccessful.')
      return (NULL)
      }
  }

  if(response$status_code != 200){
    stop(paste(response$status_code,":", content$error$message))
  }

  return (content$shows$items[[1]]$id)

}


#' Search for a new podcast
#'
#' @param keywords string: The search query
#' @param language string: (optional, defaults to ENGLISH)
#' @param market string: (optional, defaults to US) Returns shows that are available in that market
#' @param explicit logical: (optional, defaults to TRUE) To enable the filter set explict to FALSE
#' @param limit integer: (optional, defaults to 5, min = 1, max = 50) Number of shows to be returned
#' @param authentication_token Predefined argument which runs getAuthenticationToken()
#'
#' @return Dataframe containing the podcast name, publisher, language, explicit content filter and podcast ID
#' @export
#'
#' @examples
#' searchForPodcast('History')
#' searchForPodcast('History', language='es')
#' searchForPodcast('History', language='es', market='ES')
#' searchForPodcast('History', language='es', market='ES', explicit=FALSE)
#' searchForPodcast('History', language='es', market='ES', explicit=FALSE, limit=10)
searchForPodcast <- function(keywords, language = 'en', market='US', explicit = TRUE, limit=5, authentication_token = getAuthenticationToken()){

  if (is.logical(explicit)==FALSE){
    stop('Incorrect filter! Please select TRUE or FALSE')
  }

  if (limit>50){
    stop('Please reduce the number of episodes to be extracted!')
  }

  if (is.character(language)==TRUE & nchar(language)!=2){
    stop('Only ISO 639-1 codes are accepted at the moment!')
  }

  if (is.character(market)==TRUE & nchar(market)!=2){
    stop('Only ISO 3166-1 alpha-2 country codes are accepted at the moment!')
  }

  if (is.character(market)==FALSE){
    stop('Please enter an ISO 3166-1 alpha-2 country code!')
  }

  base_url = 'https://api.spotify.com/v1/search'
  response <- httr::GET(base_url,
                  query = list(q = enc2utf8(keywords),
                               type = 'show',
                               market=market),
                  httr::add_headers(Accept = 'application/json',
                              Authorization = paste('Bearer', authentication_token)))

  content <- httr::content(response)

  if(response$status_code != 200){
    stop(paste(response$status_code,":", content$error$message))
  }


  podcast_name = list()
  podcast_publisher = list()
  podcast_id = list()
  explicit_content = list()
  podcast_language = list()

  search_limit = content$shows$limit


  for (i in 1:search_limit){
    podcast_name[[i]] <- content$shows$items[[i]]$name
    podcast_publisher[[i]] <- content$shows$items[[i]]$publisher
    podcast_id[[i]] <- content$shows$items[[i]]$id
    explicit_content[[i]] <- content$shows$items[[i]]$explicit
    podcast_language[[i]] <- stringr::str_sub(tolower(content$shows$items[[i]]$language[[1]]),-2)
  }

  podcast_search = data.frame(unlist(podcast_name),
                              unlist(podcast_publisher),
                              unlist(explicit_content),
                              unlist(podcast_language),
                              unlist(podcast_id)
  )
  colnames(podcast_search) <- c('Podcast Name', 'Podcast Publisher', 'Explicit','Language', 'Podcast ID')

  if (explicit == FALSE){
    podcast_df <- subset(podcast_search, Explicit == FALSE & Language == tolower(language))
    return(podcast_df[1:limit, ])
  }

  else{
    podcast_df <- subset(podcast_search, Language == tolower(language))
    return(podcast_df[1:limit, ])
  }

}


#' Get Recent Episodes
#'
#' @param podcast_id string: The show's ID
#' @param explicit logical: (optional, defaults to TRUE) To enable the filter set explict to FALSE
#' @param limit integer: (optional, defaults to 5, min = 1, max = 50) Number of episodes to be returned
#' @param market string: (optional, defaults to US) Returns shows that are available in that market
#' @param duration numeric: (optional, defaults to NA) Returns episodes under that are under the specified duration (in minutes)
#' @param authentication_token Predefined argument which runs getAuthenticationToken()
#'
#' @return Dataframe containing the episode name, release date, duration, explicit content filter and ID
#' @export
#'
#' @examples
#' getRecentEpisodes('5RdShpOtxKO3ZWohR2M6Sv')
getRecentEpisodes <- function(podcast_id, explicit = TRUE, limit=5, market='US', duration=NA, authentication_token = getAuthenticationToken()){

  if (is.logical(explicit)==FALSE){
    stop('Incorrect filter! Please select TRUE or FALSE')
  }

  if (limit>50){
    stop('Please reduce the number of episodes to be extracted!')
  }

  if ((is.numeric(duration)==FALSE & is.na(duration)==FALSE) | (is.numeric(duration)==TRUE & duration<=0)){
    stop('Please recheck your value for duration!')
  }

  if (is.character(market)==TRUE & nchar(market)!=2){
    stop('Only ISO 3166-1 alpha-2 country codes are accepted at the moment!')
  }

  if (is.character(market)==FALSE){
    stop('Please enter an ISO 3166-1 alpha-2 country code!')
  }


  base_url = glue::glue('https://api.spotify.com/v1/shows/{podcast_id}/episodes')
  response <- httr::GET(base_url,
                  query = list(limit=50,
                               market = market),
                  httr::add_headers(Accept = 'application/json',
                              Authorization = paste('Bearer', authentication_token)))

  content <- httr::content(response)

  if(response$status_code != 200){
    stop(paste(response$status_code,":", content$error$message))
  }


  episode_name = list()
  release_date = list()
  episode_duration = list()
  explicit_content = list()
  episode_id = list()

  search_limit = content$limit


  for (i in 1:search_limit){
    episode_name[[i]] <- content$item[[i]]$name
    release_date[[i]] <- content$item[[i]]$release_date
    episode_duration[[i]] <- round((content$item[[i]]$duration_ms)/(1000*60),0)
    explicit_content[[i]] <- content$item[[i]]$explicit
    episode_id[[i]] <- content$item[[i]]$id
  }


  recent_episodes = data.frame(unlist(episode_name),
                               unlist(release_date),
                               unlist(episode_duration),
                               unlist(explicit_content),
                               unlist(episode_id)
  )
  colnames(recent_episodes) <- c('Episode Name', 'Release Date', 'Duration','Explicit', 'Episode ID')


  if (explicit == FALSE){
    recent_episodes_df <- subset(recent_episodes, Explicit == FALSE)
    if (is.na(duration) == FALSE){
      recent_episodes_df <- subset(recent_episodes_df, Duration <= duration)
      return(recent_episodes_df[1:limit, ])
    }
    else{
      return(recent_episodes_df[1:limit, ])
    }

  }

  else{
    if (is.na(duration) == FALSE){
      recent_episodes_df <- subset(recent_episodes, Duration <= duration)
      return(recent_episodes_df[1:limit, ])
    }
    else{
      return(recent_episodes[1:limit, ])
    }
  }

}


#' Get Episode Information
#'
#' @param episode_id string: The episode's ID
#' @param market string: string: (optional, defaults to US) Returns shows that are available in that market
#' @param authentication_token Predefined argument which runs getAuthenticationToken()
#'
#' @return a DataFrame that contains the name and a brief discription of the episode.
#' @export
#'
#' @examples
#' getEpisodeInformation('4nRWJ76Tu0ceXJj3uJc4D7')
getEpisodeInformation <- function(episode_id, market='US', authentication_token = getAuthenticationToken()){

  if (is.character(episode_id)==FALSE){
    stop('episode_id must be a string')
  }

  if (is.character(market)==TRUE & nchar(market)!=2){
    stop('Only ISO 3166-1 alpha-2 country codes are accepted at the moment!')
  }

  if (is.character(market)==FALSE){
    stop('Please enter an ISO 3166-1 alpha-2 country code!')
  }

  base_url = glue::glue('https://api.spotify.com/v1/episodes/{episode_id}')
  response <- httr::GET(base_url,
                  query = list(market = market),
                  httr::add_headers(Accept = 'application/json',
                              Authorization = paste('Bearer', authentication_token)))

  content <- httr::content(response)

  if(response$status_code != 200){
    stop(paste(response$status_code,":", content$error$message))
  }

  episode_name = content$name
  episode_description = content$show$description
  episode_information = data.frame(episode_name, episode_description)

  return (episode_information)

}

#### Plot Podcast Stats ####

#' Get Basic Stats
#'
#' In this release the function plots the duration of episodes over time. More functionality will be added in future releases
#'
#' @param podcast_id The show's ID
#' @param limit integer: (optional, defaults to 5, min = 1, max = 50) Number of episodes to be returned
#' @param authentication_token Predefined argument which runs getAuthenticationToken()
#'
#' @return a plot
#' @export
#'
#' @examples
#' getBasicStats('2FLQbu3SLMIrRIDM0CaiHG')
getBasicStats <- function(podcast_id, limit=50, authentication_token = getAuthenticationToken()){

  response <- getRecentEpisodes(podcast_id, limit = limit)

  ggplot2::ggplot(response,
                  ggplot2::aes(as.Date(`Release Date`), Duration)) +
    ggplot2::geom_line() +
    ggplot2::labs(title='Duartion of Episodes Over Time',
                  x='Release Date',
                  y='Duration (minutes)')
}
