require 'nokogiri'
require 'open-uri'

def get_info(word, sort, page)
  url = 'https://qiita.com/tags/' + word + "/" + sort + "?page=" + page

  charset = nil
  html = open(url) do |f|
    charset = f.charset
    f.read
  end

  doc = Nokogiri::HTML.parse(html, nil, charset)
  list = doc.xpath('//article/div/div[@class="ItemLink__title"]')

  list

end

def get_url
  "http://qiita.com"
end
