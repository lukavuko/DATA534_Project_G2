
<!-- README.md is generated from README.Rmd. Please edit that file -->

# wrappify

<!-- badges: start -->

[![R-CMD-check](https://github.com/adityasal/DATA534_Project_G2/workflows/R-CMD-check/badge.svg)](https://github.com/adityasal/DATA534_Project_G2/actions)
[![Devtools-test](https://github.com/adityasal/DATA534_Project_G2/workflows/y/badge.svg)](https://github.com/adityasal/DATA534_Project_G2/actions)

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
devtools::install_github("adityasal/DATA534_Project_G2")
```

## Example

This is a basic example that shows the intended workflow of wrappify. We
start by loading our credentials from system variables and generate an
authentication token.

``` r
source("R/EricsFunctions.R")
#> -- Attaching packages --------------------------------------- tidyverse 1.3.0 --
#> v ggplot2 3.3.2     v purrr   0.3.4
#> v tibble  3.0.4     v dplyr   1.0.2
#> v tidyr   1.1.2     v stringr 1.4.0
#> v readr   1.4.0     v forcats 0.5.0
#> -- Conflicts ------------------------------------------ tidyverse_conflicts() --
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()
#> 
#> Attaching package: 'jsonlite'
#> The following object is masked from 'package:purrr':
#> 
#>     flatten
#> 
#> Attaching package: 'glue'
#> The following object is masked from 'package:dplyr':
#> 
#>     collapse
#> Loading required package: usethis
source("R/LukaFunctions.R")
source("R/spotifyPodcastAPI.R")

client_id <-  Sys.getenv('CLIENT_ID')
secret_id <-  Sys.getenv('CLIENT_SECRET_ID')

get_authentication_token(client_id, secret_id)
#> [1] "BQBpp09rJFnPBURkh9Ip4u7ZaPWcxu9kUk3H2RM4hgEf7Vw_-3_JeTO3b_TprXDxlMm5kZMFJ8Uu2k1fBmM"
```

First, we have an artist we wish to know more about. That artist is the
essential alternative metal band “Ghost”. We query getArtistInfo.

``` r
ghost <- getArtistInfo("Ghost", byName = TRUE)
ghost
#>                    name popularity              genres followers
#> 1            Ghostemane         78           dark trap   1739446
#> 2                 Ghost         69           hard rock   1008883
#> 3       KIDS SEE GHOSTS         67             hip hop    725063
#> 4      Ghostface Killah         66 alternative hip hop    584552
#> 5            Ghostluvme         56             Unknown     10274
#> 6                 GHØST         49             Unknown        39
#> 7  In Love With a Ghost         62  kawaii future bass    233781
#> 8        Ghost and Pals         57             otacore     59637
#> 9     Jukebox The Ghost         59           indie pop    148034
#> 10           GHOST DATA         58       dark clubbing     70715
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
#> 10          Year Zero 1YBf7Tq9bpcVwvnlP8YbQS         50      5.836433
```

We are interested in knowing more about the song “Dance Macabre”, so we
pull out the song ID and use it to generate a graph of audio features.

``` r
dance <- ghostsongs[1,]$id
getAudioFeatures(dance, output = "graph")
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" /> We
learn that we really like Ghost, and want to get some similar artists.

``` r
getRelatedArtists(id)
#>                 name                     id
#> 1           Mastodon 1Dvfqq39HxvCJ3GvfeIFuT
#> 2          Kvelertak 0VE0GTaTSeeGSzrQpLmeb9
#> 3         Candlemass 7zDtfSB0AOZWhpuAHZIOw5
#> 4         Arch Enemy 0DCw6lHkzh9t7f8Hb4Z0Sx
#> 5          Testament 28hJdGN1Awf7u3ifk2lVkg
#> 6       King Diamond 5i0ph60TnwTlIGrOZAmcZa
#> 7             Gojira 0GDGKpJFhVpcjIGF8N6Ewt
#> 8           Amorphis 2UOVgpgiNTC6KK0vSC77aD
#> 9              Opeth 0ybFZ2Ab08V8hueghSXm6E
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

# LUKA

We may also be interested in learning about new music which fits certain
metrics and genre tags

# ADITYA

Or, if we would prefer to listen to a podcast, we can use wrappify as
well.

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this. You could also
use GitHub Actions to re-render `README.Rmd` every time you push. An
example workflow can be found here:
<https://github.com/r-lib/actions/tree/master/examples>.
