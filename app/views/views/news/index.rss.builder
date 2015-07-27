xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Your Blog Title"
    xml.description "A blog about software and chocolate"
    xml.link news_url

    for news in @news
      xml.item do
        xml.title news.title
        xml.description post.content
        xml.pubDate post.posted_at.to_s(:rfc822)
        xml.link post_url(news)
        xml.guid post_url(news)
      end
    end
  end
end
