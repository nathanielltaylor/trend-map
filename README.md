![Build Status](https://codeship.com/projects/c042def0-4cf7-0133-5535-566112b803ab/status?branch=master)
![Code Climate](https://codeclimate.com/github/nathanielltaylor/trend-map.png)

## TweetMaps

An interactive mapping app that provides a sleek geographic interface to Twitter data on what people are talking about where, as well as analyses of how they feel about it.

## Features

[Trello board](https://trello.com/b/PmEn0OA2/trend-map) (currently private)

(Starred features are under consideration)

#### User Profiles
- [X] User sign up and authentication
- [X] User is publicly identified only by username
- [ ] Personalized user dashboard based on connected Twitter account*

#### Mapping
- [X] Interactive map
- [X] Tweets superimposed on map
- [X] Trends superimposed on map
- [X] Fully JavaScript overlays
- [ ] User location maps*

#### Data Querying
- [X] Trends searchable
- [X] Locations searchable
- [X] User searches are saved to personalize experience
- [X] User can delete searches permanently
- [ ] User can hide their searches from other users without deleting them*

#### Recommendation Features
- [X] Ability to add recommended queries
- [X] Search recommendations with any number of parameters
- [X] Ability to vote on recommendations

#### Data Storage
- [X] Tweets stored in database for 3 minutes
- [X] Trends stored in database for 20 minutes

#### Sentiment analysis
- [X] By topic
- [X] By location
- [ ] Overall analysis on homepage*
- [ ] Visualized on heatmaps*

Next goal: Try to implement Google-powered translation of tweets

##### Original Icon Design Credits
"trend" by Daouna Jeong. "trend" by Ryo Sato. "hashtag" by juan manjarrez. "hashtag" by matthew hall. "Location" by Creative Stall. "Target" by luc vega. "Smile", "displeased", and "Sad" by Golden Roof. All from the Noun Project.

## Local Development

I welcome all positive contributions. To contribute to this project:
- Fork and clone down this repository
- You will need seven API keys to run this app, which should be placed in a .env file
  - The first four are obtained from Twitter. Register your version of the app, and then add the four keys you receive under the names TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET, TWITTER_ACCESS_TOKEN, and TWITTER_CONSUMER_SECRET
  - You will also need keys from Google, Yahoo, and indico.io. Name these GOOGLE_GEOCODING, YAHOO, and INDICO
- Note while running the test suite that some of the tests are disabled by default in the .rspec file:
  - The tests in spec/apis serve as a quick connectivity dashboard; they can be run to ensure that nothing has changed in the configuration of the APIs that the application uses. They should only be run if the APIs themselves seem to be behaving irregularly in order to better diagnose the problem. Running them repeatedly over a short period of time will quickly burn through your quota of Twitter API calls. 
