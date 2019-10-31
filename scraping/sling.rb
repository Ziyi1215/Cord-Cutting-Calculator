require 'open-uri'
require 'nokogiri'
require 'json'
require 'httparty'

class Scraper
    attr_accessor :parse_page
    def initialize
        doc = HTTParty.get('https://www.sling.com')
        @parse_page ||= Nokogiri::HTML(doc)
    end
end

scraper = Scraper.new()

scraper.parse_page.css('//div[@data-sling-tab-name]').each do |category|
    addon_category = category['data-sling-tab-name']
    puts "***************"
    puts addon_category
    puts "***************"
    category.css('.carousel-jam_channel-container').css('img').each do |image|
        puts image['alt']
    end
    cost = category.css('.carousel-jam_heading').text[/[\d]+/]
    puts cost
end