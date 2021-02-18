#### Loading Dependencies ####

library(httr)
library(jsonlite)
library(utils)
library(glue)
library(stringr)
library(ggplot2)

#### Authentication Function ####

#' Authentication Token 
#' 
#' Get an Authentication Token for the Spotify API.
#' A token is only valid for a few hours. If a 401 
#' error is raised rerun the function to get a new
#' token. 
#'
#' @param client_id string: (Visit https://developer.spotify.com/dashboard for more information)
#' @param client_secret_id string: (Visit https://developer.spotify.com/dashboard for more information)
#'
#' @return authentication token saved to a global variable authentication_token
#' @export
#'
#' @examples 
#' getAuthenticationToken(client_id, client_secret_id)
 
getAuthenticationToken <- function(client_id, client_secret_id){
  if (is.character(client_id) == FALSE | is.character(client_secret_id) == FALSE){
    stop('Client ID/Client Secret ID must be a string value')
  }
  response = POST('https://accounts.spotify.com/api/token',
                  accept_json(),
                  authenticate(client_id, client_secret_id),
                  body = list(grant_type = 'client_credentials'),
                  encode = 'form',
                  verbose())
  if(response$status_code != 200){
    stop(paste(response$status_code,":", content(response)$error$message))
  }
  authentication_token <<- content(response)$access_token
  return (authentication_token)
}


#' Get Show ID
#' 
#' Retrieves a podcast ID from a general name search query
#'
#' @param query string: The show to search for 
#' @param market string: (optional, defaults to US) A string returning shows that are available in that market 
#'
#' @return A string containing the show's ID
#' @export
#'
#' @examples
#' getPodcastID('Philosophize This!', market='US')
#' getPodcastID('Philosophize This!')

getPodcastID <- function(query, market='US'){
  
  
  if (is.character(market)==TRUE & nchar(market)!=2){
    stop('Only ISO 3166-1 alpha-2 country codes are accepted at the moment!')
  }
  
  if (is.character(market)==FALSE){
    stop('Please enter an ISO 3166-1 alpha-2 country code!')
  }
  
  base_url = 'https://api.spotify.com/v1/search'
  response <- GET(base_url, 
                  query = list(q = enc2utf8(query),
                               type = 'show',
                               market=market),
                  add_headers(Accept = 'application/json', 
                              Authorization = paste('Bearer', authentication_token)))
  
  if(response$status_code != 200){
    stop(paste(response$status_code,":", content(response)$error$message))
  }
  
  
  response = content(response)
  return (response$shows$items[[1]]$id)
  
}


#' Search for a new podcast 
#'
#' @param keywords string: The search query 
#' @param language string: (optional, defaults to ENGLISH) 
#' @param market string: (optional, defaults to US) Returns shows that are available in that market 
#' @param explicit logical: (optional, defaults to TRUE) To enable the filter set explict to FALSE
#' @param limit integer: (optional, defaults to 5, min = 1, max = 50) Number of shows to be returned
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

searchForPodcast <- function(keywords, language = 'en', market='US', explicit = TRUE, limit=5){
  
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
  response <- GET(base_url, 
                  query = list(q = enc2utf8(keywords),
                               type = 'show',
                               market=market),
                  add_headers(Accept = 'application/json', 
                              Authorization = paste('Bearer', authentication_token)))
  
  if(response$status_code != 200){
    stop(paste(response$status_code,":", content(response)$error$message))
  }
  
  
  podcast_name = list()
  podcast_publisher = list()
  podcast_id = list()
  explicit_content = list()
  podcast_language = list()
  response = content(response)
  
  search_limit = response$shows$limit
  
  
  for (i in 1:search_limit){
    podcast_name[[i]] <- response$shows$items[[i]]$name
    podcast_publisher[[i]] <- response$shows$items[[i]]$publisher
    podcast_id[[i]] <- response$shows$items[[i]]$id
    explicit_content[[i]] <- response$shows$items[[i]]$explicit 
    podcast_language[[i]] <- str_sub(tolower(response$shows$items[[i]]$language[[1]]),-2)
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
    return(head(podcast_df, limit))
  }
  
  else{
    podcast_df <- subset(podcast_search, Language == tolower(language))
    return(head(podcast_df, limit))
  }
  
}


#' Get Recent Episodes 
#'
#' @param podcast_id string: The show's ID 
#' @param explicit logical: (optional, defaults to TRUE) To enable the filter set explict to FALSE
#' @param limit integer: (optional, defaults to 5, min = 1, max = 50) Number of episodes to be returned
#' @param market string: (optional, defaults to US) Returns shows that are available in that market 
#' @param duration numeric: (optional, defaults to NA) Returns episodes under that are under the specified duration (in minutes)
#'
#' @return Dataframe containing the episode name, release date, duration, explicit content filter and ID
#' @export
#'
#' @examples 
#' getRecentEpisodes('5RdShpOtxKO3ZWohR2M6Sv')

getRecentEpisodes <- function(podcast_id, explicit = TRUE, limit=5, market='US', duration=NA){
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
  
  
  base_url = glue('https://api.spotify.com/v1/shows/{podcast_id}/episodes')
  response <- GET(base_url, 
                  query = list(limit=50,
                               market = market),
                  add_headers(Accept = 'application/json', 
                              Authorization = paste('Bearer', authentication_token)))
  
  if(response$status_code != 200){
    stop(paste(response$status_code,":", content(response)$error$message))
  }
  
  response = content(response)
  
  episode_name = list()
  release_date = list()
  episode_duration = list()
  explicit_content = list()
  episode_id = list()
  
  search_limit = response$limit
  
  
  for (i in 1:search_limit){
    episode_name[[i]] <- response$item[[i]]$name
    release_date[[i]] <- response$item[[i]]$release_date
    episode_duration[[i]] <- round((response$item[[i]]$duration_ms)/(1000*60),0)
    explicit_content[[i]] <- response$item[[i]]$explicit
    episode_id[[i]] <- response$item[[i]]$id
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
      return(head(recent_episodes_df,limit))
    }
    else{
      return(head(recent_episodes_df, limit))   
    }
    
  }
  
  else{
    if (is.na(duration) == FALSE){
      recent_episodes_df <- subset(recent_episodes, Duration <= duration)
      return(head(recent_episodes_df, limit))
    }
    else{
      return(head(recent_episodes, limit))   
    }
  }
  
}


#' Get Episode Information
#'
#' @param episode_id string: The episode's ID
#' @param market string: string: (optional, defaults to US) Returns shows that are available in that market 
#'
#' @return a DataFrame that contains the name and a brief discription of the episode.
#' @export
#'
#' @examples
#' episode_id('4nRWJ76Tu0ceXJj3uJc4D7')

getEpisodeInformation <- function(episode_id, market='US'){
  
  if (is.character(episode_id)==FALSE){
    stop('episode_id must be a string')
  }
  
  if (is.character(market)==TRUE & nchar(market)!=2){
    stop('Only ISO 3166-1 alpha-2 country codes are accepted at the moment!')
  }
  
  if (is.character(market)==FALSE){
    stop('Please enter an ISO 3166-1 alpha-2 country code!')
  }
  
  base_url = glue('https://api.spotify.com/v1/episodes/{episode_id}')
  response <- GET(base_url,
                  query = list(market = market),
                  add_headers(Accept = 'application/json', 
                              Authorization = paste('Bearer', authentication_token)))
  
  if(response$status_code != 200){
    stop(paste(response$status_code,":", content(response)$error$message))
  }
  
  response = content(response)
  
  episode_name = response$name
  episode_description = response$show$description
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
#'
#' @return a plot 
#' @export
#'
#' @examples
#' getBasicStats('2FLQbu3SLMIrRIDM0CaiHG')
#' 
getBasicStats <- function(podcast_id, limit=50){
  response <- getRecentEpisodes(podcast_id, limit = limit)
  ggplot(response,
         aes(as.Date(`Release Date`),
             Duration)) + geom_line() + labs(title='Duartion of Episodes Over Time', 
                                             x='Release Date',
                                             y='Duration (minutes)')
}