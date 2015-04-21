require 'rss'
require 'feedjira'

class PostsController < ApplicationController

 def index

#@rss = RSS::Parser.parse(open('https://business.illinois.edu/news/college/feed/').read, false).items[0..2]

feed =Feedjira::Feed.fetch_and_parse("http://rss.cnn.com/rss/cnn_topstories.rss")
@entry = feed.entries


 end
end




