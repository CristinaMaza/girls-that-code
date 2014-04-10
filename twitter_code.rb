=begin
I appoligize in advanced for the many steps to get this program installed.  
But once it is installed, you can do amazing things!

online documentation to help with scrapping
http://nokogiri.org/
http://ruby.bastardsbook.com/chapters/html-parsing/

first you have to install nokogiri (see http://nokogiri.org/tutorials/installing_nokogiri.html for details):

windows
 - go to http://rubyinstaller.org/downloads/, look for 'DEVELOPMENT KIT' on the left and select the right file, most likely the first one
 - after download is complete, double click on file and select to extract to: C:\DevKit
 - open the command prompt (Start button > type in cmd in search bar)
 - run the following commands:
cd c:\DevKit
ruby dk.rb init
ruby dk.rb install
gem install nokogiri

Please do the following steps if you get the following error: "C:\Ruby193/lib/ruby/1.9.1/net/http.rb:8000:in 'connect':SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed <OpenSSL: :SSL: :SSlError>"
- go to https://gist.github.com/fnichol/867550 and follow the instructions


mac (easy way, most likely will not work)
 - open terminal and type the following:
brew install libxml2 libxslt libiconv
brew link libxml2 libxslt libiconv
gem install nokogiri

mac (hard way if easy way does not work)
 - open terminal and type the following:
cd ~/Downloads
ARCHFLAGS=-Wno-error=unused-command-line-argument-hard-error-in-future brew install libxml2 libxslt
brew link libxml2 libxslt
brew install wget
wget http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.13.1.tar.gz
tar xvfz libiconv-1.13.1.tar.gz
cd libiconv-1.13.1
./configure --prefix=/usr/local/Cellar/libiconv/1.13.1
make
sudo make install
sudo gem install nokogiri -- --with-xml2-include=/usr/local/Cellar/libxml2/2.7.8/include/libxml2 --with-xml2-lib=/usr/local/Cellar/libxml2/2.7.8/lib --with-xslt-dir=/usr/local/Cellar/libxslt/1.1.26 --with-iconv-include=/usr/local/Cellar/libiconv/1.13.1/include --with-iconv-lib=/usr/local/Cellar/libiconv/1.13.1/lib

linux
sudo apt-get install ruby1.8-dev ruby1.8 ri1.8 rdoc1.8 irb1.8
sudo apt-get install libreadline-ruby1.8 libruby1.8 libopenssl-ruby
sudo apt-get install libxslt-dev libxml2-dev
sudo gem install nokogiri

=end


# the twitter url you want to scrape
url = 'https://twitter.com/jsgeorgia'
puts "the url we are scrapping is: #{url}"



###########################
## You can ignore the steps
## starting here until the 
## next big block of comments
## - this code pulls in twitter
##   feed and creates list 
##   of its data
###########################


# have to require these gems to be able to get content from urls
require 'rubygems'
require 'nokogiri'
require 'open-uri'

# pull in the twitter page
doc = Nokogiri::HTML(open(url))

# write out the page title
puts "the page title of this url is: #{doc.at_css("title").content.strip}"

# get the username for this page
username = doc.at_css('.profile-card-inner h2.username').content.strip
puts "the username for this page is: #{username}"

# get all of the tweets
doc_tweets = doc.css('#timeline ol#stream-items-id li .tweet')
puts "there are #{doc_tweets.length} tweets on this page"

# for each tweet, lets pull out the following and save into a list.
# 0 - date
# 1 - status
# 2 - name
# 3 - username
# 4 - is this a retweet?
# 5 - link
# this list will then be added to the variable list tweets
tweets = []
doc_tweets.each do |tweet|
  tweet_item = []
  # get the time of the tweet
  time = tweet.at_css(".content .time span")['data-time']
  # convert time in # of seconds to a time object
  tweet_item[0] = time.nil? ? nil : Time.at(time.to_i)

  # get the status
  tweet_item[1] = tweet.at_css(".content p.tweet-text").content.strip
  
  # get the name of person posting tweet
  tweet_item[2] = tweet.at_css(".content .account-group .fullname").content.strip

  # get the username of person posting tweet
  tweet_item[3] = tweet.at_css(".content .account-group .username").content.strip

  # is this a re-tweet?
  tweet_item[4] = !tweet.at_css(".context .js-retweet-text").nil?

  # link to tweet
  tweet_item[5] = "https://twitter.com/" + tweet.at_css(".content .time a")['href']

  # add this tweet item to the list of all tweets
  tweets << tweet_item
end
puts "we pulled out and processed #{tweets.length} tweets"


###########################
## Data now exists in 'tweets' 
## list variable.
## Have fun and play!
###########################

# you now have a variable called tweets that is an array of all tweets
# each tweet in tweets is also an array with the following information
# tweet = [date, status, name, username, is_retweet?, url]
# remember that the array index starts at 0!


# see how many usernames match the username of this page
username_count = tweets.select{|x| x[3] == username}.length
puts "out of #{tweets.length}, #{username_count} were written by #{username}"

puts "------------------"

# an example we did in class
# on average, how many words are in each tweet
# - create a variable called word count to record the number of words
word_count = 0
# go through each tweet and count the words
# - to do this, first we split the text by a space ' ' to get all words and
#   then we count the length
# - here we are using a new symbol '+='
#   - this is a shorthand notation 
#   - instead of writing word_count = word_count + tweet[1].split(' ').length
#     we can write word_count += tweet[1].split(' ').length
tweets.each{|tweet| word_count += tweet[1].split(' ').length }
# now comput the average
# - remember from previous class that in order to get a decimal, 
#   we have to tell ruby that at least one of the numbers should be float, hence to_f below
average = word_count / tweets.length.to_f
puts "the average number of words per tweet is: #{average}"


puts "------------------"

###########################
###########################
# homework for class 7 starts here
###########################
###########################
=begin

For this homework, we want to get a list of the most used hashtags and usernames in all of the tweets.
A hashtag is any word that starts with '#'
A username is any word that start with '@'

This assignment can be complex so I tried to walk you through the steps of what to do.  If you have any questions please ask!

Here are the tasks for you to accomplish.  
After each task, please use a puts statement to write out what you just did in nice, pretty text.
- get list of all words in all tweet text
  - create a variable called text
  - set text equal to the result of tweets.map to get just the status text
  - create a variable called words
  - set words equal to the result of applying join and split to text to get an array of words
    
- get all words that are hashtags (start with '#')
  - create variable called hashtags 
  - set hashtags equal to the result of using a words.select statement
  - in the select statement you want to test if the first character in a string is a '#'
    - a string is just an array of characters, so you can get the first character using string[0]
    - so to test if the word is a hashtag, you will have something like this
      in your select statement: select{|word| word[0] == '#'}
      
- create variable called usernames and populate with all words that start with '@' (similar to last task)

- create variable called hashtags_uniq and store the unique values from hashtags in it

- create variable called usernames_uniq and store the unique values from usernames in it

- for each unique hashtag, count how many times it appears in the variable hashtags
  - create new empty array called hashtag_count
    - this array is going to hold an array of a unique hashtag and a count of how many times it appears: [hashtag, count]
  - use hashtags_uniq.each and do the following inside of it:
    - create a variable called count
    - set count equal to how many times the unique hashtag appears in hashtags by using hashtags.select and length
    - add the hashtag name and count to the hashtag_count array (e.g., hashtag_count << [hashtag, count])

- for each unique username, count how many times it appears in the variable usernames  (similar to last task)

- sort hashtag_count by count in descending order and use ! to save the result back to hashtag_count
  - remember the hashtag_count array is made up of arrays of [hashtag, count] so count has an index of 1

- sort username_count by count in descending order and use ! to save the result back to username_count

- finally, show the hashtags that have a count greater than 1 in a pretty string format
  - create variable called popular_hashtags
  - set popular_hashtags equal to the result of using hashtag_count.select to get all hashtags with count greater than 1
  - create variable called popular_hashtags_mapped
  - set popular_hashtags_mapped equal to the result of popular_hashtags.map to format the result into a string of 'hashtag - count'
    - remember to use "#{}" syntax to do this
  - when writing your puts statement, use a popular_hashtags_mapped.join statement to make it look pretty
  
- finally, show the usernames that have a count greater than 1 in a pretty string format  (similar to last task)

Now, on line 51 is the following statement: url = 'https://twitter.com/jsgeorgia'
If you want, try picking another twitter page and re-run the code to see 
what the most popular hashtags and usernames are for that twitter page! 

=end

puts "----------------------------------"

text = tweets.map {|tweet| tweet[1]}

puts "text: #{text}"

textIntoString = text.join(" ")

puts "textIntoString: #{textIntoString}"

words = textIntoString.split(" ")

puts "here are all of the words #{words}"
hashtags = words.select {|word| word[0]== '#'}

usernames = words.select {|word| word [0]== '@'}

hashtagsunique = hashtags.uniq 

puts hashtagsunique 

usernamesunique = usernames.uniq 

hashtagcount = []

hashtagsunique.each {|unique|
  count = hashtags.select{|hashtag| hashtag == unique}.length
  hashtagcount << [unique, count]
}

puts hashtagcount 
puts '-------------------------------'

usernamescount = []

usernamesunique.each {|unique|
  count = usernames.select {|username| username == unique}.length 
  usernamescount << [unique, count]

}

puts usernamescount 

puts '-------------------------------'

hashtagcount.sort! {|cat, dog| dog[1]<=>cat[1]}



puts hashtagcount 
puts '-------------------------------'



usernamescount.sort! {|james, margret| margret[1]<=>james[1]}

puts usernamescount 

puts '-------------------------------'

puts usernamescount[0]

puts "The most frequently used username is #{usernamescount[0][0]} appearing #{usernamescount[0][1]} times" 

puts "The most frequently used hashtag is #{hashtagcount[0][0]} appearing #{hashtagcount[0][1]} times" 


