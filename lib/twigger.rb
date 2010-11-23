ActiveRecord::Base.table_name_prefix = "pligg_"

class Comment < ActiveRecord::Base
  set_primary_key "comment_id"
end

class Link < ActiveRecord::Base
  set_primary_key "link_id"
end

class Twigger
  VERSION = '1.1.0'

  def self.ingest_by_search(search_term)
    search = Twitter::Search.new
    cnt = 0
    tweets = search.containing(search_term).fetch
    tweets.each do |tweet|
      next if Link.find_by_link_field1("#{tweet.id}")
      l = create_link(tweet, search_term)
      cnt += 1
    end
    return cnt
  end

  def self.create_link(tweet, search_term = nil)
    l = Link.new
    l.link_category       = 1
    l.link_author         = 1
    l.link_status         = "published"
    l.link_votes          = 0
    l.link_published_date = tweet.created_at
    l.link_content        = tweet.text
    l.link_url_title      = tweet.id
    l.link_title_url      = tweet.id
    l.link_summary        = tweet.text
    l.link_tags           = "twitter"
    l.link_votes          = 1
    l.link_url = "http://twitter.com/#{tweet.twitter_handle}/statuses/#{tweet.uid}"
    l.link_title          = "From @#{tweet.from_user} via Twitter"
    l.link_field6         = tweet.from_user
    l.link_field5         = "twitter"
    l.link_field4         = tweet.from_user
    l.link_field3         = tweet.to_user
    l.link_field2         = search_term
    l.link_field1         = "#{tweet.id}"

    l.save
    return l
  end
end
