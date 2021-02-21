Wrappify
================

<!-- README.md is generated from README.Rmd. Please edit that file -->

Note: All OS tests will sometimes pass or fail when CI is run and we
can’t figure out why. We believe that sometimes tests will run on a
remote server in a location where the API is region locked, causing the
tests to fail.

<!-- badges: start -->

[![R-CMD-check](https://github.com/adityasal/DATA534_Project_G2/workflows/R-CMD-check/badge.svg)](https://github.com/adityasal/DATA534_Project_G2/actions)
[![Build
Status](https://travis-ci.org/lukavuko/wrappify.svg?branch=main)](https://travis-ci.org/lukavuko/wrappify)
[![codecov](https://codecov.io/gh/lukavuko/wrappify/branch/main/graph/badge.svg?token=3XUUH12N1B)](https://codecov.io/gh/lukavuko/wrappify)
<!-- badges: end -->

Wrappify is an API wrapper for the Spotify API in R. Currently, there is
functionality only for the API functions which do not require access to
an individuals data.

## Installation

You can install the released version of wrappify from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("wrappify")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("lukavuko/wrappify")
```

## Example 1: Obtaining Song and Artist Information

This is a basic example that shows the intended workflow of wrappify.

First, we have an artist we wish to know more about. That artist is the
essential alternative metal band “Ghost”. We query getArtistInfo.

``` r
ghost <- getArtistInfo("Ghost", byName = TRUE)
ghost
#>                    name popularity              genres followers
#> 1            Ghostemane         78           dark trap   1743756
#> 2                 Ghost         70           hard rock   1009697
#> 3       KIDS SEE GHOSTS         67             hip hop    726385
#> 4      Ghostface Killah         66 alternative hip hop    585101
#> 5            Ghostluvme         56             Unknown     10106
#> 6                 GHØST         49             Unknown        40
#> 7  In Love With a Ghost         62  kawaii future bass    234022
#> 8        Ghost and Pals         57             otacore     60009
#> 9     Jukebox The Ghost         59           indie pop    148202
#> 10           GHOST DATA         58       dark clubbing     70956
#>                        id
#> 1  3uL4UpqShC4p2x1dJutoRW
#> 2  1Qp56T7n950O3EGMsSl81D
#> 3  2hPgGN4uhvXAxiXQBIXOmE
#> 4  6FD0unjzGQhX3b6eMccMJe
#> 5  6KtRA9pyDcbDyanI7bfU8W
#> 6  4kDvW6OahLASc5O7aSeIgI
#> 7  21tDFddcOFDYmiobTcls2O
#> 8  3Avni6DLpoxtanND8mG5t8
#> 9  0L8jXe7QeS9oYUoXbANmX4
#> 10 042mLfOBpH8OoX8A6sUYhf
```

We see that Ghost is the second artist in the list. We pull out the
Spotify ID and use it to get Ghost’s top songs.

``` r
id <- ghost[2,]$id

ghostsongs <- getTopSongs(id)
#> Token: Is defined
#> Token Validity: Valid
ghostsongs
#>                  song                     id popularity duration_mins
#> 1       Dance Macabre 1E2WTcYLP1dFe1tiGDwRmT         58      3.662000
#> 2       Square Hammer 2XgTw2co6xv95TmKpMcL70         57      3.988217
#> 3     Mary On A Cross 2HZLXBOnaSRhXStMLrq9fD         57      4.080067
#> 4    Kiss The Go-Goat 56k2ztFw7hQRzDeoe80pJo         55      3.261550
#> 5              Cirice 3ZXZ9RMsznqgyHnyq0K5FL         54      6.034883
#> 6                Rats 4u39IY2QjY1utpNCCF4is0         53      4.359550
#> 7              Ritual 5ZiTzbMB53mIiP3I4uQCmt         50      4.479100
#> 8               He Is 4ExR43GqMe2KwWM3VPGUmO         46      4.219550
#> 9  If You Have Ghosts 1sNSlzvQ5jPir46X5X1TeH         51      3.581333
#> 10          Year Zero 1YBf7Tq9bpcVwvnlP8YbQS         51      5.836433
```

We are interested in knowing more about the song “Dance Macabre”, so we
pull out the song ID and use it to generate a graph of audio features.

``` r
dance <- ghostsongs[1,]$id
getAudioFeatures(dance, output = "graph")
#> Token: Is defined
#> Token Validity: Valid
#> Token: Is defined
#> Token Validity: Valid
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" /> We
learn that we really like Ghost, and want to get some similar artists.

``` r
getRelatedArtists(id)
#> Token: Is defined
#> Token Validity: Valid
#>                 name                     id
#> 1           Mastodon 1Dvfqq39HxvCJ3GvfeIFuT
#> 2          Kvelertak 0VE0GTaTSeeGSzrQpLmeb9
#> 3         Candlemass 7zDtfSB0AOZWhpuAHZIOw5
#> 4         Arch Enemy 0DCw6lHkzh9t7f8Hb4Z0Sx
#> 5          Testament 28hJdGN1Awf7u3ifk2lVkg
#> 6       King Diamond 5i0ph60TnwTlIGrOZAmcZa
#> 7             Gojira 0GDGKpJFhVpcjIGF8N6Ewt
#> 8              Opeth 0ybFZ2Ab08V8hueghSXm6E
#> 9           Amorphis 2UOVgpgiNTC6KK0vSC77aD
#> 10   Type O Negative 0blJzvevdXrp21YeI2vbco
#> 11       Amon Amarth 3pulcT2wt7FEG10lQlqDJL
#> 12          Baroness 3KdXhEwbqFHfNfSk7L9E87
#> 13      Dimmu Borgir 6e8ISIsI7UQZPyEorefAhK
#> 14            Avatar 4jpaXieuls7LVzG1uma5Rs
#> 15           Kreator 3BM0EaYmkKWuPmmHFUTQHv
#> 16 Children Of Bodom 1xUhNgw4eJDZfvumIpcz1B
#> 17         In Flames 57ylwQTnFnIhJh4nu4rxCs
#> 18          Behemoth 1MK0sGeyTNkbefYGj673e9
#> 19 Dark Tranquillity 5EHvXKnNz78jkAVgTQLQ5O
#> 20     Paradise Lost 0gIo6kGl4KsCeIbqtZVHYp
```

And now we can choose one of these artists that look interesting and
learn more about them as well.

## Example 2: Conversion of Artist/Song names to their IDs

Spotify has a ID code associated with each object in its database which
acts as a unique identifier. Human beings, however, know their favourite
artists, tracks, and podcasts by name, not abstract IDs. As such,
functionality is needed to convert names into IDs for use in other
functions.

Note that artist and track names do not need to be formatted or spelled
correctly to yield valid search results. We have a list of artists we
want to use in other functions:

``` r
# One artist, mispelled
getArtistID('sanTanana')
#> Searching artist: sanTanana
#> Token: Is defined
#> Token Validity: Valid
#> Artist Found:  Santana
#>   Artist.name              Artist.ID Artist.Popularity
#> 1     Santana 6GI52t8N5F02MxU0g5U69P                74
#>                                                 Genres
#> 1 blues rock, classic rock, mexican classic rock, rock


# Multiple artists, seamlessly
artists_of_interest <- c('alt j', 'vulfpeck', 'herbie hancock0')

do.call(rbind, lapply(artists_of_interest, getArtistID))
#> Searching artist: alt j
#> Token: Is defined
#> Token Validity: Valid
#> Artist Found:  alt-J
#> Searching artist: vulfpeck
#> Token: Is defined
#> Token Validity: Valid
#> Artist Found:  Vulfpeck
#> Searching artist: herbie hancock0
#> Token: Is defined
#> Token Validity: Valid
#> Artist Found:  Herbie Hancock
#>      Artist.name              Artist.ID Artist.Popularity
#> 1          alt-J 3XHO7cRUPCLOr6jwp8vsx5                75
#> 2       Vulfpeck 7pXu47GoqSYRajmBCjxdD6                66
#> 3 Herbie Hancock 2ZvrvbQNrHKwjT7qfGFFUW                63
#>                                                                                                                        Genres
#> 1                                                                                                     indie rock, modern rock
#> 2                                                                         ann arbor indie, funk, funk rock, instrumental funk
#> 3 bebop, contemporary post-bop, cool jazz, funk, instrumental funk, jazz, jazz funk, jazz fusion, jazz piano, soul, soul jazz
```

When searching for tracks you can also include artist names to narrow
down what track you’re looking for!

``` r
# Song limit defaults to 5
getTrackID('Love')
#> Searching track: Love
#> Token: Is defined
#> Token Validity: Valid
#>                         Track.Name          Track.Artist               Track.ID
#> 1                                                                              
#> 2    Love Story (Taylor’s Version)          Taylor Swift 3CeCwYWvdfXbZLXFhBrbnf
#> 3             lovely (with Khalid) Billie Eilish, Khalid 0u2P5u6lvoDfwTYjAADbn4
#> 4          What You Know Bout Love             Pop Smoke 1tkg4EHVoqnhR6iFEXb60y
#> 5 Love Galore (feat. Travis Scott)     SZA, Travis Scott 0q75NwOoFiARAVp4EXU4Bs
#> 6                      WITHOUT YOU         The Kid LAROI 27OeeYzk6klgBh83TSvGMA
#>   Track.Popularity
#> 1                 
#> 2               85
#> 3               87
#> 4               91
#> 5               79
#> 6               93

# User can increase limits
getTrackID('Love', limit = 10)
#> Searching track: Love
#> Token: Is defined
#> Token Validity: Valid
#>                          Track.Name           Track.Artist
#> 1                                                         
#> 2     Love Story (Taylor’s Version)           Taylor Swift
#> 3              lovely (with Khalid)  Billie Eilish, Khalid
#> 4           What You Know Bout Love              Pop Smoke
#> 5  Love Galore (feat. Travis Scott)      SZA, Travis Scott
#> 6                       WITHOUT YOU          The Kid LAROI
#> 7                     love language          Ariana Grande
#> 8                 Someone You Loved          Lewis Capaldi
#> 9                         Love Sosa             Chief Keef
#> 10                    Electric Love                  BØRNS
#> 11              LOVE. FEAT. ZACARI. Kendrick Lamar, Zacari
#>                  Track.ID Track.Popularity
#> 1                                         
#> 2  3CeCwYWvdfXbZLXFhBrbnf               85
#> 3  0u2P5u6lvoDfwTYjAADbn4               87
#> 4  1tkg4EHVoqnhR6iFEXb60y               91
#> 5  0q75NwOoFiARAVp4EXU4Bs               79
#> 6  27OeeYzk6klgBh83TSvGMA               93
#> 7  4iIrJ94pkIEnGZWv1MhIRC               48
#> 8  7qEHsqek33rTcFNT9PFqLf               89
#> 9  4IowQDUOzUvNtp72HMDcKO               74
#> 10 2GiJYvgVaD2HtM8GqD9EgQ               84
#> 11 6PGoSes0D9eUDeeAafB2As               77

# User can search with artist name in the string for more precise results
getTrackID('Love whitney houston')
#> Searching track: Love whitney houston
#> Token: Is defined
#> Token Validity: Valid
#>                                   Track.Name          Track.Artist
#> 1                                                                 
#> 2                                Higher Love Kygo, Whitney Houston
#> 3 I Wanna Dance with Somebody (Who Loves Me)       Whitney Houston
#> 4                     Love Will Save the Day       Whitney Houston
#> 5                                Higher Love Kygo, Whitney Houston
#> 6                     I Will Always Love You       Whitney Houston
#>                 Track.ID Track.Popularity
#> 1                                        
#> 2 6oJ6le65B3SEqPwMRNXWjY               80
#> 3 2tUBqZG2AbRi7Q0BIrVrEj               81
#> 4 4gDBc1RxPAvinJrZzZ9nYX               42
#> 5 1kKYjjfNYxE0YYgLa7vgVY               67
#> 6 4eHbdreAnSOrDDsFfc4Fpm               76
```

## Example 3: Exploring New Tracks

We may also be interested in searching for new music based on certain
song metrics (danceability, energy, valence, etc.), artist styles, genre
tags, and even songs themselves. For this we have the
`getTrackRecommendations()` function.

Artist to ID conversion is built into the `getTrackRecommendations`
function so we can directly type names into the function.

Track to ID conversion is not yet implemented so we will use track seeds
from earlier to find new song recommendations. There seem to be some
issues with track seeds as vectors so we’ll use only single tracks as
our seed.

Genres can be types as a vector if wanting multiple genres. Most genre
tags you can think of exist in the Spotify API search, but in case
there’s no return try using other genre names.

``` r
# I want more songs like 'Higher Love' by Kygo and Whitney Houston
getTrackRecommendations(seed_artists = c('kygo', 'whitney houston'),
                        seed_genres = c('tropical house', 'edm'),
                        seed_tracks = '6oJ6le65B3SEqPwMRNXWjY')
#> Searching artist: kygo
#> Token: Is defined
#> Token Validity: Valid
#> Artist Found:  Kygo
#> Searching artist: whitney houston
#> Token: Is defined
#> Token Validity: Valid
#> Artist Found:  Whitney Houston
#> Token: Is defined
#> Token Validity: Valid
```

<img src="man/figures/README-unnamed-chunk-8-1.png" width="100%" />

    #> [[1]]
    #>                                        Track.Name
    #> 1                                                
    #> 2                                      The Middle
    #> 3                                    Say You Will
    #> 4                                  I Have Nothing
    #> 5       What I Like About You (feat. Theresa Rex)
    #> 6             You - Tiësto vs. Twoloud Radio Edit
    #> 7    Bruised Not Broken (feat. MNEK & Kiana Ledé)
    #> 8                                       Spotlight
    #> 9       Tough Love (feat. Agnes, Vargas & Lagola)
    #> 10                                        Forever
    #> 11                                       Unpretty
    #> 12                                    Do It To Me
    #> 13                 In My Mind (Axwell Radio Edit)
    #> 14                     Feel So Close - Nero Remix
    #> 15                  Ain't No Mountain High Enough
    #> 16 When the Going Gets Tough, The Tough Get Going
    #> 17                    Back In Time - Extended Mix
    #> 18                              It's All About Me
    #> 19                                Say You, Say Me
    #> 20                       Inside Out (feat. Griff)
    #> 21                                         Chimes
    #>                                Track.Artist               Track.ID
    #> 1                                                                 
    #> 2                  Zedd, Maren Morris, Grey 09IStsImFySgyp0pIQdqAc
    #> 3        Kygo, Patrick Droney, Petey Martin 5vDjcNbN4m9fxWcrpR64Wu
    #> 4                           Whitney Houston 31er9IGsfFbwqy1pH4aiTP
    #> 5                   Jonas Blue, Theresa Rex 4NSW0Km5ZG60L8FthUebPJ
    #> 6                 Galantis, Tiësto, Twoloud 5kC6r4q71XMzsuLAYesseb
    #> 7                  Matoma, MNEK, Kiana Ledé 2ak79ho44RiDi9DFrqYgfq
    #> 8                      Marshmello, Lil Peep 6VrCmhRBFnuGKmtNfk4jDs
    #> 9            Avicii, Agnes, Vargas & Lagola 1yfyIdEw5U2bD5I6gxQCxW
    #> 10                                     Pope 42prDRVUOkgzQsfSFL2mmL
    #> 11                                      TLC 0BUoLE4o9eVahDHvTqak67
    #> 12                            Lionel Richie 4tzqUn1y5GNrV0dKV9S5vC
    #> 13 Ivan Gough & Feenixpawl feat. Georgi Kay 3bXptsvAsA4gLaaRKMHsr0
    #> 14                            Calvin Harris 4vyEY2Nd22H4ErNjSv2qzq
    #> 15                               Diana Ross 1KbuhBnzMHp4eq1q6flhWd
    #> 16                              Billy Ocean 5UU5FbITNm5OunvHQdsKME
    #> 17                               Don Diablo 3Bk2bWV7RLpzGea7EkZ8o7
    #> 18                                      Mýa 4Wtk0YYWUcx1JYicaq5Jd0
    #> 19                            Lionel Richie 17CPezzLWzvGfpZW6X8XT0
    #> 20                              Zedd, Griff 6IiCb4PCrDgqLuDWgHhFi7
    #> 21                           Hudson Mohawke 1U3oH5CRRcjT5TT69b6eYl
    #>    Track.Popularity Explicit.Status
    #> 1                                  
    #> 2                81           FALSE
    #> 3                58           FALSE
    #> 4                72           FALSE
    #> 5                69           FALSE
    #> 6                38           FALSE
    #> 7                58           FALSE
    #> 8                74           FALSE
    #> 9                62           FALSE
    #> 10               19           FALSE
    #> 11               61           FALSE
    #> 12               57           FALSE
    #> 13               49           FALSE
    #> 14                0           FALSE
    #> 15               57           FALSE
    #> 16               63           FALSE
    #> 17                0           FALSE
    #> 18               55           FALSE
    #> 19               69           FALSE
    #> 20               69           FALSE
    #> 21                3           FALSE
    #>                                               Track.Link
    #> 1                                                       
    #> 2  https://open.spotify.com/track/09IStsImFySgyp0pIQdqAc
    #> 3  https://open.spotify.com/track/5vDjcNbN4m9fxWcrpR64Wu
    #> 4  https://open.spotify.com/track/31er9IGsfFbwqy1pH4aiTP
    #> 5  https://open.spotify.com/track/4NSW0Km5ZG60L8FthUebPJ
    #> 6  https://open.spotify.com/track/5kC6r4q71XMzsuLAYesseb
    #> 7  https://open.spotify.com/track/2ak79ho44RiDi9DFrqYgfq
    #> 8  https://open.spotify.com/track/6VrCmhRBFnuGKmtNfk4jDs
    #> 9  https://open.spotify.com/track/1yfyIdEw5U2bD5I6gxQCxW
    #> 10 https://open.spotify.com/track/42prDRVUOkgzQsfSFL2mmL
    #> 11 https://open.spotify.com/track/0BUoLE4o9eVahDHvTqak67
    #> 12 https://open.spotify.com/track/4tzqUn1y5GNrV0dKV9S5vC
    #> 13 https://open.spotify.com/track/3bXptsvAsA4gLaaRKMHsr0
    #> 14 https://open.spotify.com/track/4vyEY2Nd22H4ErNjSv2qzq
    #> 15 https://open.spotify.com/track/1KbuhBnzMHp4eq1q6flhWd
    #> 16 https://open.spotify.com/track/5UU5FbITNm5OunvHQdsKME
    #> 17 https://open.spotify.com/track/3Bk2bWV7RLpzGea7EkZ8o7
    #> 18 https://open.spotify.com/track/4Wtk0YYWUcx1JYicaq5Jd0
    #> 19 https://open.spotify.com/track/17CPezzLWzvGfpZW6X8XT0
    #> 20 https://open.spotify.com/track/6IiCb4PCrDgqLuDWgHhFi7
    #> 21 https://open.spotify.com/track/1U3oH5CRRcjT5TT69b6eYl
    #> 
    #> [[2]]
    #> NULL

Say we aren’t satisfied with our list. We can use other parameters to
better guide Spotify’s recommendation API like so:

``` r
getTrackRecommendations(seed_artists = c('kygo', 'whitney houston'),
                        seed_genres = c('tropical house', 'edm'),
                        seed_tracks = '6oJ6le65B3SEqPwMRNXWjY',
                        limit = 12,
                        market = 'US',
                        min_popularity = 70,
                        target_valence = 1)
#> Searching artist: kygo
#> Token: Is defined
#> Token Validity: Valid
#> Artist Found:  Kygo
#> Searching artist: whitney houston
#> Token: Is defined
#> Token Validity: Valid
#> Artist Found:  Whitney Houston
#> Token: Is defined
#> Token Validity: Valid
```

<img src="man/figures/README-unnamed-chunk-9-1.png" width="100%" />

    #> [[1]]
    #>                                                Track.Name
    #> 1                                                        
    #> 2                                                  Sucker
    #> 3                              Tick Tock (feat. 24kGoldn)
    #> 4                              Feel So Close - Radio Edit
    #> 5                                     Running Back To You
    #> 6                                               Instagram
    #> 7                                                  Nobody
    #> 8                            God Is A Dancer (with Mabel)
    #> 9                               Head & Heart (feat. MNEK)
    #> 10 Feels (feat. Pharrell Williams, Katy Perry & Big Sean)
    #> 11                                          Family Affair
    #> 12                                              Lush Life
    #> 13                                                Ride It
    #>                                                                                                 Track.Artist
    #> 1                                                                                                           
    #> 2                                                                                             Jonas Brothers
    #> 3                                                                              Clean Bandit, Mabel, 24kGoldn
    #> 4                                                                                              Calvin Harris
    #> 5                                                                    Martin Jensen, Alle Farben, Nico Santos
    #> 6  Dimitri Vegas & Like Mike, David Guetta, Daddy Yankee, Afro Bros, Natti Natasha, Dimitri Vegas, Like Mike
    #> 7                                                                                              NOTD, Catello
    #> 8                                                                                              Tiësto, Mabel
    #> 9                                                                                           Joel Corry, MNEK
    #> 10                                          Calvin Harris, Pharrell Williams, Katy Perry, Big Sean, Funk Wav
    #> 11                                                                                             Mary J. Blige
    #> 12                                                                                              Zara Larsson
    #> 13                                                                                                    Regard
    #>                  Track.ID Track.Popularity Explicit.Status
    #> 1                                                         
    #> 2  22vgEDb5hykfaTwLuskFGD               81           FALSE
    #> 3  27u7t9d7ZQoyjsCROHuZJ3               82           FALSE
    #> 4  1gihuPhrLraKYrJMAEONyc               79           FALSE
    #> 5  7feeLzB9KdKJ2ha3OvJ0SZ               70           FALSE
    #> 6  0U6bQIAh6MCGo1xjbIIx2S               72            TRUE
    #> 7  7GiozRoMk95aFl1WbrDdjX               72           FALSE
    #> 8  6fenHIxXuuzKB55wY4WCHP               72           FALSE
    #> 9  6cx06DFPPHchuUAcTxznu9               89           FALSE
    #> 10 5bcTCxgc7xVfSaMV3RuVke               73            TRUE
    #> 11 3aw9iWUQ3VrPQltgwvN9Xu               70           FALSE
    #> 12 1rIKgCH4H52lrvDcz50hS8               75           FALSE
    #> 13 2tnVG71enUj33Ic2nFN6kZ               85           FALSE
    #>                                               Track.Link
    #> 1                                                       
    #> 2  https://open.spotify.com/track/22vgEDb5hykfaTwLuskFGD
    #> 3  https://open.spotify.com/track/27u7t9d7ZQoyjsCROHuZJ3
    #> 4  https://open.spotify.com/track/1gihuPhrLraKYrJMAEONyc
    #> 5  https://open.spotify.com/track/7feeLzB9KdKJ2ha3OvJ0SZ
    #> 6  https://open.spotify.com/track/0U6bQIAh6MCGo1xjbIIx2S
    #> 7  https://open.spotify.com/track/7GiozRoMk95aFl1WbrDdjX
    #> 8  https://open.spotify.com/track/6fenHIxXuuzKB55wY4WCHP
    #> 9  https://open.spotify.com/track/6cx06DFPPHchuUAcTxznu9
    #> 10 https://open.spotify.com/track/5bcTCxgc7xVfSaMV3RuVke
    #> 11 https://open.spotify.com/track/3aw9iWUQ3VrPQltgwvN9Xu
    #> 12 https://open.spotify.com/track/1rIKgCH4H52lrvDcz50hS8
    #> 13 https://open.spotify.com/track/2tnVG71enUj33Ic2nFN6kZ
    #> 
    #> [[2]]
    #> NULL

For user interest, a pie chart is provided to view what proportion of
returned content is explicit. In the future we would like to integrate
optional plot parameters, and other optional plots that can highlight
song popularity and general genre music metrics such as their energy,
acousticness, liveness, and so forth.

``` r
getTrackRecommendations(seed_artists = c('kygo', 'whitney houston'),
                        seed_genres = c('tropical house', 'edm'),
                        seed_tracks = '6oJ6le65B3SEqPwMRNXWjY',
                        limit = 12,
                        market = 'US',
                        target_energy = 0.8,
                        target_danceability = 1,
                        target_valence = 1)
#> Searching artist: kygo
#> Token: Is defined
#> Token Validity: Valid
#> Artist Found:  Kygo
#> Searching artist: whitney houston
#> Token: Is defined
#> Token Validity: Valid
#> Artist Found:  Whitney Houston
#> Token: Is defined
#> Token Validity: Valid
```

<img src="man/figures/README-unnamed-chunk-10-1.png" width="100%" />

    #> [[1]]
    #>                                                Track.Name
    #> 1                                                        
    #> 2  Feels (feat. Pharrell Williams, Katy Perry & Big Sean)
    #> 3                                           Keep You Mine
    #> 4                                                  Sucker
    #> 5                                                 Ride It
    #> 6          When the Going Gets Tough, The Tough Get Going
    #> 7           Treat You Better - Purple Disco Machine Remix
    #> 8                                               Your Song
    #> 9                                                  Nobody
    #> 10                                             Like Sugar
    #> 11                                    Jump (Original Mix)
    #> 12                                          Monkey Island
    #> 13                                          Family Affair
    #>                                                        Track.Artist
    #> 1                                                                  
    #> 2  Calvin Harris, Pharrell Williams, Katy Perry, Big Sean, Funk Wav
    #> 3                                                  NOTD, SHY Martin
    #> 4                                                    Jonas Brothers
    #> 5                                                            Regard
    #> 6                                                       Billy Ocean
    #> 7                                RÜFÜS DU SOL, Purple Disco Machine
    #> 8                                                          Rita Ora
    #> 9                                                     NOTD, Catello
    #> 10                                                       Chaka Khan
    #> 11                                              The Pointer Sisters
    #> 12                                                          Dubmood
    #> 13                                                    Mary J. Blige
    #>                  Track.ID Track.Popularity Explicit.Status
    #> 1                                                         
    #> 2  5bcTCxgc7xVfSaMV3RuVke               73            TRUE
    #> 3  0OJN2A3Qyvd7pwSF0AIteC               67           FALSE
    #> 4  22vgEDb5hykfaTwLuskFGD               81           FALSE
    #> 5  2tnVG71enUj33Ic2nFN6kZ               85           FALSE
    #> 6  5UU5FbITNm5OunvHQdsKME               63           FALSE
    #> 7  6MLvUL2dYphJTwgiBvuJ1J               45           FALSE
    #> 8  4c2W3VKsOFoIg2SFaO6DY5               66           FALSE
    #> 9  7GiozRoMk95aFl1WbrDdjX               72           FALSE
    #> 10 0lWEatZXBBYUzEQX5aMeSj               59           FALSE
    #> 11 1kIu9zpYtWjgrLlsactlna               65           FALSE
    #> 12 30sHxvIflGaWj7nnd3oSTo               35           FALSE
    #> 13 3aw9iWUQ3VrPQltgwvN9Xu               70           FALSE
    #>                                               Track.Link
    #> 1                                                       
    #> 2  https://open.spotify.com/track/5bcTCxgc7xVfSaMV3RuVke
    #> 3  https://open.spotify.com/track/0OJN2A3Qyvd7pwSF0AIteC
    #> 4  https://open.spotify.com/track/22vgEDb5hykfaTwLuskFGD
    #> 5  https://open.spotify.com/track/2tnVG71enUj33Ic2nFN6kZ
    #> 6  https://open.spotify.com/track/5UU5FbITNm5OunvHQdsKME
    #> 7  https://open.spotify.com/track/6MLvUL2dYphJTwgiBvuJ1J
    #> 8  https://open.spotify.com/track/4c2W3VKsOFoIg2SFaO6DY5
    #> 9  https://open.spotify.com/track/7GiozRoMk95aFl1WbrDdjX
    #> 10 https://open.spotify.com/track/0lWEatZXBBYUzEQX5aMeSj
    #> 11 https://open.spotify.com/track/1kIu9zpYtWjgrLlsactlna
    #> 12 https://open.spotify.com/track/30sHxvIflGaWj7nnd3oSTo
    #> 13 https://open.spotify.com/track/3aw9iWUQ3VrPQltgwvN9Xu
    #> 
    #> [[2]]
    #> NULL

## Example 3: Podcasts

If we would prefer information on podcasts, we can use wrappify as well.

Podcasts, like songs and artists, are uniquely identified by their
Spotify ID. We can convert key words into this ID using getPodcastID.

``` r
getPodcastID('conspiracy theory')
#> Token: Is defined
#> Token Validity: Valid
#> [1] "5RdShpOtxKO3ZWohR2M6Sv"
```

A list of recent episodes can be generated using this ID.

``` r
getRecentEpisodes('5RdShpOtxKO3ZWohR2M6Sv', limit=5)
#> Token: Is defined
#> Token Validity: Valid
#>                           Episode Name Release Date Duration Explicit
#> 1                       Peak Oil Pt. 2   2021-02-17       40    FALSE
#> 2                       Peak Oil Pt. 1   2021-02-15       39    FALSE
#> 3   Danny Casolaro & The Octopus Pt. 2   2021-02-10       43    FALSE
#> 4   Danny Casolaro & The Octopus Pt. 1   2021-02-08       46    FALSE
#> 5 New Limited Series: Criminal Couples   2021-02-04        1    FALSE
#>               Episode ID
#> 1 4wZc2l5ZAEhX9wquq1nNrm
#> 2 4nRWJ76Tu0ceXJj3uJc4D7
#> 3 4RZfiKSM5dytiaQw7Q7hXd
#> 4 0SGrl1HSnNGv8w5G8sGLB6
#> 5 4DEjNTTeQcxHgZMl1OhwWi
```

If we only have 30 minutes to spare, the duration filter can be used.

``` r
getRecentEpisodes('5RdShpOtxKO3ZWohR2M6Sv', duration = 30, limit=5)
#> Token: Is defined
#> Token Validity: Valid
#>                            Episode Name Release Date Duration Explicit
#> 5  New Limited Series: Criminal Couples   2021-02-04        1    FALSE
#> 11  Welcome to the Family: The Kennedys   2021-01-19        1    FALSE
#> 23              Introducing: Science Vs   2020-11-19       29    FALSE
#> 36               All New! Superstitions   2020-10-13       13    FALSE
#> NA                                 <NA>         <NA>       NA       NA
#>                Episode ID
#> 5  4DEjNTTeQcxHgZMl1OhwWi
#> 11 0X4uXvFA8gfQ7PKzejMmYR
#> 23 1rECoP64UbepFsO8sV3xE0
#> 36 1UcbprjllCLM7yGHpc1TAj
#> NA                   <NA>
```

We can also check out some basic stats. Right now, duration of episodes
can be plotted over time. However, more graphical functionality is
planned in the future.

``` r
getBasicStats('5RdShpOtxKO3ZWohR2M6Sv')
#> Token: Is defined
#> Token Validity: Valid
```

<img src="man/figures/README-unnamed-chunk-14-1.png" width="100%" />

`searchForPodcast` can be used to find a new show. How about a
child-friendly Spanish podcast on history? Type in `history`, change the
language to `es` and change `explicit` to `FALSE` .

``` r
searchForPodcast('history', language = 'es', market = 'ES', explicit = FALSE)
#> Token: Is defined
#> Token Validity: Valid
#>                                      Podcast Name          Podcast Publisher
#> 1                                    SER Historia                 Cadena SER
#> 2 Curiosidades de la Historia National Geographic National Geographic España
#> 3            Historia de España para selectividad             Podium Podcast
#> 4                        HISTORIAS DE LA HISTORIA                 VIVA RADIO
#> 5                           Historia con el móvil             Podium Podcast
#>   Explicit Language             Podcast ID
#> 1    FALSE       es 0nFMjIf5dk2X4gfv9wnRNf
#> 2    FALSE       es 5LpYg29KE8rckzwEj2JGmS
#> 3    FALSE       es 1ukhoriiZiLoxTNW6ZQTeE
#> 4    FALSE       es 39wGmvob0nYl6L1klXiew9
#> 5    FALSE       es 55iNyxqAXcGiX9S1GlsVPn
```
