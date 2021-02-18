# source('R/spotifyPodcastAPI.R')
library(testthat)

#### Initializing Authentication Token ####

client_id = Sys.getenv('CLIENT_ID')
client_secret_id = Sys.getenv('CLIENT_SECRET_ID')
authentication_token = getAuthenticationToken(client_id = client_id,
                                              client_secret_id = client_secret_id)

#### Testing getAuthenticationToken Function ####

test_that('A test to check if an error is raised on entering an invalid client or secret ID',
          {
            expect_error(getAuthenticationToken('abcd',1))
            expect_error(getAuthenticationToken('abcd','abcd'))
          })

#### Testing searchForPodcast ####

test_that('A test to check if an error is raised on entering invalid arguments',
          {
            expect_error(searchForPodcast(1))
            expect_error(searchForPodcast('History',market = 7))
            expect_error(searchForPodcast('Philosophy',explicit = 'G'))
            expect_error(searchForPodcast('Formula 1',limit = 100))
            expect_error(searchForPodcast('EPL',language = 'GGGGG'))
          })

test_response_elm <- searchForPodcast(keywords = 'History',
                                      language = 'ES',
                                      market = 'ES',
                                      explicit = FALSE)

test_response_el_t <- searchForPodcast(keywords = 'History',
                                       explicit = TRUE,
                                       limit = 10)


test_that('Checking whether the output is of type data.frame',
          {
            expect_equal(class(test_response_elm),'data.frame')
          })


test_that('Checking filters',
          {
            expect_false(any(test_response_elm$Explicit==TRUE))
            expect_false(any(test_response_elm$language!='es'))
            expect_equal(nrow(searchForPodcast(keywords = 'History',
                                               limit = 5)),5)
          })



#### Testing getPodcastID Function ####
test_that(' A test to check if an error is raised on entering invalid arguments',
          {
            expect_error(getPodcastID('Philosophize This!',market = 7))
            expect_error(getPodcastID('Philosophize This!', market='AAA'))
            expect_error(getPodcastID(1, market='AAA'))
})

test_that('A test to check whether a valid podcast ID is returned',
          {
            expect_equal(getPodcastID('Philosophize This!'),'2Shpxw7dPoxRJCdfFXTWLE')
            expect_equal(getPodcastID('Conspiracy Theories Parcast'),'5RdShpOtxKO3ZWohR2M6Sv')
          })

#### Testing getRecentEpisodes Function ####

test_that('A test to check if an error is raised on entering invalid arguments',
          {
            expect_error(getRecentEpisodes(1))
            expect_error(getRecentEpisodes('2Shpxw7dPoxRJCdfFXTWLE',market = 7))
            expect_error(getRecentEpisodes('2Shpxw7dPoxRJCdfFXTWLE',explicit = 'G'))
            expect_error(getRecentEpisodes('2Shpxw7dPoxRJCdfFXTWLE',limit = 100))
            expect_error(getRecentEpisodes('2Shpxw7dPoxRJCdfFXTWLE',duration = 'TwentyMinutes'))
          })

test_response_eld_t <- getRecentEpisodes(podcast_id = '2FLQbu3SLMIrRIDM0CaiHG',
                                         duration = 40)

test_response_e_f <- getRecentEpisodes(podcast_id = '2FLQbu3SLMIrRIDM0CaiHG',
                                       explicit = FALSE)

test_that('Checking whether the output is of type data.frame',
          {
          expect_equal(class(getRecentEpisodes(podcast_id = '2FLQbu3SLMIrRIDM0CaiHG')),'data.frame')
            })


test_that('Checking filters',
          {
            expect_false(any(test_response_e_f$Explicit==TRUE))
            expect_true(any(test_response_eld_t$Explicit==TRUE))
            expect_false(any(test_response_eld_t$Duration>40))
            expect_equal(nrow(getRecentEpisodes(podcast_id = '2FLQbu3SLMIrRIDM0CaiHG',
                                            limit = 5)),5)
          })

#### Testing getEpisodeInformation Function ####

test_that('A test to check if an error is raised on entering invalid arguments',
          {
            expect_error(getEpisodeInformation(1))
            expect_error(getEpisodeInformation('1'))
            expect_error(getEpisodeInformation('3xUldphixY3rZnjxhfMxCK',market = 7))
          })


test_that('Checking the output',
          {
            expect_equal(class(getEpisodeInformation(episode_id = '3xUldphixY3rZnjxhfMxCK')),'data.frame')
            expect_equal(getEpisodeInformation(episode_id = '3xUldphixY3rZnjxhfMxCK')$episode_name,
                         'Chris Chan: A Comprehensive History - Part 42')
          })
