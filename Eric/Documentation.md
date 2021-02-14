# get_authentication_token

### Description

Get an authentication token from the Spotify API, allowing for use by the user.

### Usage

`token <- get_authentication_token(client_id, client_secret_id)`

### Arguments

`client_id`: A users id code. Can be found at `https://developer.spotify.com/dashboard`

`client_secret_id`: Similar to `client_id`

### Details

An authentication token only remains valid for a few hours, so this function needs to be rerun at the beginning of sessions.

# getArtistInfo

### Description

Gives the description of a single artist if searched by Spotify id, or a list of possible matches if searched for by name. Output can be the raw json data, or organized in a dataframe.

### Usage

`getArtistInfo(authentication_token, artist, byName = FALSE, dataframe = TRUE, lim = 10)`

### Arguments

`authentication_token`: A code authorizing access to the API. can be found using `get_authentication_token`

`artist`: Either an artists Spotify ID or a search query

`byName`: Boolean to determine whether the `artist` parameter is an artist ID or an artist name. `byName = TRUE` searches by name, `byName = FALSE` searches by ID.

`dataframe`: Whether the function output should be a dataframe or a json object.

`lim`: How many results should be displayed when searched by name.

# getSongInfo

### Description

Gives the description of a single song if searched by Spotify id, or a list of possible matches if searched for by name. Output can be the raw json data, or organized in a dataframe.

### Usage

`getSongInfo(authentication_token, song, byName = FALSE, dataframe = TRUE, lim = 10)`

### Arguments

`authentication_token`: A code authorizing access to the API. can be found using `get_authentication_token`

`song`: Either a songs Spotify ID, or a search query

`byName`: Boolean to determine whether the `song` parameter is a song ID or an song name. `byName = TRUE` searches by name, `byName = FALSE` searches by ID.

`dataframe`: Whether the function output should be a dataframe or a json object.

`lim`: How many results should be displayed when searched by name.


# getRelatedArtists

### Description

Gives a list of similar artists to the users input.

### Usage

`getRelatedArtists(authentication_token, artistId, dataframe =  TRUE)`

### Arguments

`authentication_token`: A code authorizing access to the API. can be found using `get_authentication_token`.

`artistId`: An artists Spotify Id.

`dataframe`: Whether the function output should be a dataframe or a json object.


# getTopSongs

### Description

Returns an artists most popular songs.

### Usage

`getTopSongs(authentication_token, artistId, output =  "dataframe", region = "CA")`

### Arguments

`authentication_token`: A code authorizing access to the API. can be found using `get_authentication_token`.

`artistId`: An artists Spotify Id.

`output`: Whether the function output should be a dataframe, json object, or popularity graph. 

- `output = "dataframe"` returns a dataframe with columns `song_name`, `id`, `popularity`, `duration` (in minutes). 

- `output = json` returns an unedited json object

- `output = graph` returns a ggplot of each songs popularity.

`region`: The two letter region code in which to search. Default `CA` (Canada).

