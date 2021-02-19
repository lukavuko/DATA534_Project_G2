#' Get an API authentication token.
#'
#' Retrieves an Authentication Token for the Spotify API.
#' The function is called when the API is called so
#' expired tokens are refreshed when needed automatically
#'
#' @param CLIENT_ID A Spotify client ID which the user needs to acquire prior to using the package.
#' @param CLIENT_SECRET A Spotify client secret key which the user needs to acquire prior to using the package.
#'
#' @return auth_token
#' @export
#'
#' @examples
#' getAuthenticationToken(CLIENT_ID, CLIENT_SECRET)
getAuthenticationToken <- function (CLIENT_ID = "7870a259411b4c8b8d2ad173b5a7ed73",
                                    CLIENT_SECRET = "67ab42b91f224c3682ff8d5b2220f6aa") {

  if (is.character(CLIENT_ID) == FALSE | is.character(CLIENT_SECRET) == FALSE){
    stop('Client ID/Client Secret ID must be a string value')
  }

  ## Get response using user defined Client ID and Client Secret
  response = httr::POST('https://accounts.spotify.com/api/token',
                  httr::accept_json(),
                  httr::authenticate(CLIENT_ID, CLIENT_SECRET),
                  body = list(grant_type = 'client_credentials'),
                  encode = 'form',
                  httr::verbose())

  content <- httr::content(response)

  ## If request was successful, assign a global authorization token.
  ## The user only needs to rerun the function to refresh their authorization token.
  if (is.null(content$access_token)) {
    message(paste('Status code :', response$status_code))
    message('Token authentication unsuccessful. Check credentials and try again')
    message('Error description: ', content$error_description)
    return(NULL)
  } else {
    auth_token <<- content$access_token
    return(auth_token)
  }
}
