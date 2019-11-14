require 'open-uri'
require 'nokogiri'
require 'json'
require 'httparty'

class Scraper
    attr_accessor :parse_page
    def get_url(url)
        HTTParty.get(url)
    end
    def parse_url(doc)
        @parse_page ||= Nokogiri::HTML(doc)
    end
end

scraper = Scraper.new()
scraper.parse_url(scraper.get_url('https://www.sling.com'))

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

file_list = ['orange.htm', 'blue.htm', 'orange_blue.htm']

file_list.each do |file|
    puts "***************"
    puts file
    puts "***************"
    
    all_channels_scraper = Scraper.new()
    all_channels_scraper.parse_url(File.read(file))
    
    cost_list = all_channels_scraper.parse_page.css('.dyn-grid_package-title')
    name_list = all_channels_scraper.parse_page.css('.dyn-grid_package-subtitle')
    
    cost_list.zip(name_list).each do |cost, package|
        puts package.text, cost.text[/[\d]+/]
    end
    puts
    
    puts all_channels_scraper.parse_page.css('#channelList').css('img').count
    
    all_channels_scraper.parse_page.css('#channelList').css('img').each do |image|
        puts image['alt']
    end 
end

# require 'watir'
# require 'nokogiri'
# browser = Watir::Browser.new(:chrome, {:chromeOptions => {:args => ['--headless', '--window-size=1200x600']}})
# browser.goto('https://www.sling.com/')
# html_doc = Nokogiri::HTML(browser.html)
# puts html_doc.xpath('/html/body/div[1]/main/section/div[2]/div/div[4]/div/div/div[1]/div/div/div/div/div[1]/div/div/div[2]/ul/div')
