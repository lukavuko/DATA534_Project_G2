library(httr)
library(jsonlite)
library(utils)
library(glue)


#' Title
#'
#' @param client_id 
#' @param client_secret_id 
#'
#' @return
#' @export
#'
#' @examples
#' 
getAuthenticationTtoken <- function(client_id, client_secret_id){
  response = POST('https://accounts.spotify.com/api/token',
                  accept_json(),
                  authenticate(client_id, client_secret_id),
                  body = list(grant_type = 'client_credentials'),
                  encode = 'form',
                  verbose())
  authentication_token <<- content(response)$access_token
  return (authentication_token)
}


#' Title
#'
#' @param query 
#' @param market 
#'
#' @return
#' @export
#'
#' @examples
#' 
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


#' Title
#'
#' @param keywords 
#' @param language 
#' @param market 
#' @param explicit 
#' @param limit 
#'
#' @return
#' @export
#'
#' @examples
#' 
searchForPodcast <- function(keywords, language = 'en', market='US', explicit = TRUE, limit=5){
  
  if (is.logical(explicit)==FALSE){
    stop('Incorrect filter! Please select TRUE or FALSE')
  }
  
  if (limit>50){
    stop('Please reduce the number of episodes to be extracted!')
  }
  
  if (is.character(language)==TRUE & nchar(market)!=2){
    stop('Only ISO ISO 639-1 codes are accepted at the moment!')
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
    podcast_language[[i]] <- response$shows$items[[i]]$language[[1]]
  }
  
  podcast_search = data.frame(unlist(podcast_name),
                              unlist(podcast_publisher),
                              unlist(explicit_content),
                              unlist(podcast_language),
                              unlist(podcast_id)
  )
  colnames(podcast_search) <- c('Podcast Name', 'Podcast Publisher', 'Explicit','Language', 'Podcast ID')
  
  if (explicit == FALSE){
    podcast_df <- subset(podcast_search, Explicit == FALSE & Language == language)
    return(head(podcast_df, limit))
  }
  
  else{
    podcast_df <- subset(podcast_search, Language == language)
    return(head(podcast_df, limit))
  }
  
}


#' Title
#'
#' @param podcast_id 
#' @param explicit 
#' @param limit 
#' @param market 
#' @param duration 
#'
#' @return
#' @export
#'
#' @examples
#' 
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
      recent_episodes_df <- subset(recent_episodes, Duration <= duration)
      return(recent_episodes_df)
    }
    else{
      return(head(recent_episodes_df, limit))   
    }
    
  }
  
  else{
    if (is.na(duration) == FALSE){
      recent_episodes_df <- subset(recent_episodes, Duration <= duration)
      return(recent_episodes_df)
    }
    else{
      return(head(recent_episodes, limit))   
    }
  }
  
}


#' Title
#'
#' @param episode_id 
#' @param market 
#'
#' @return
#' @export
#'
#' @examples
#' 
getEpisodeInformation <- function(episode_id, market='US'){
  
  if (is.character(episode_id)==FALSE){
    stop('epiosde_id must be a string')
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