require 'twitter'


#### Get your twitter keys & secrets:
#### https://dev.twitter.com/docs/auth/tokens-devtwittercom
twitter = Twitter::REST::Client.new do |config|
  config.consumer_key = 'o9y1q770tYuT0mI9Or5Qjgj6W'
  config.consumer_secret = 'HeRGtK6DQVxGtUDzXAEmDXnwwKNifz8VghHsuKoEcjnGDtr9VM'
  config.oauth_token = '9527012-GviSxb1b6teu9qX9RdgSKthVueoagdRspEap9CMjPq'
  config.oauth_token_secret = 'dy3giC8S2walHzASsIGk0k6PlltDgN3r1OHHprbYtpMF5'
end

search_term = URI::encode('@MaidPro')

SCHEDULER.every '10m', :first_in => 0 do |job|
  begin
    tweets = twitter.search("#{search_term}")

    if tweets
      tweets = tweets.map do |tweet|
        { name: tweet.user.name, body: tweet.text, avatar: tweet.user.profile_image_url_https }
      end
      send_event('twitter_mentions', comments: tweets)
    end
  rescue Twitter::Error
    puts "\e[33mFor the twitter widget to work, you need to put in your twitter API keys in the jobs/twitter.rb file.\e[0m"
  end
end
