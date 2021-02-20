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
#' getAuthenticationToken()
getAuthenticationToken <- function (CLIENT_ID = "7870a259411b4c8b8d2ad173b5a7ed73",
                                    CLIENT_SECRET = "67ab42b91f224c3682ff8d5b2220f6aa") {


  # Check credentials are of orrect datatype
  if (is.character(CLIENT_ID) == FALSE | is.character(CLIENT_SECRET) == FALSE){
    stop('Client ID/Client Secret ID must be a string value')
  }


  # If the auth_token was previously generated, test its validity
  if (exists('auth_token')) {

    message('Token: Is defined')
    test_url <- 'https://api.spotify.com/v1/search?q=shape%20of%20you&type=track&market=US&limit=1'
    test_response <- httr::GET(test_url, httr::add_headers(Accept = 'application/json',
                                               Authorization = paste('Bearer', auth_token)))

    # If it's valid, return the current auth_token
    if (test_response$status == 200) {

      message('Token Validity: Valid')
      return (auth_token)

      # If not valid get new auth_token using predefined Client ID and Client Secret
      } else {

        response = httr::POST('https://accounts.spotify.com/api/token',
                        httr::accept_json(),
                        httr::authenticate(CLIENT_ID, CLIENT_SECRET),
                        body = list(grant_type = 'client_credentials'),
                        encode = 'form',
                        httr::verbose())

        content <- httr::content(response)

        # If request wasn't successful, let user know
        # otherwise assign a global authorization token
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

  # It if doesn't yet exist generate an initial one
  } else {

      response = httr::POST('https://accounts.spotify.com/api/token',
                            httr::accept_json(),
                            httr::authenticate(CLIENT_ID, CLIENT_SECRET),
                            body = list(grant_type = 'client_credentials'),
                            encode = 'form',
                            httr::verbose())

      content <- httr::content(response)

      # If request wasn't successful, let user know
      # otherwise assign a global authorization token
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
}
