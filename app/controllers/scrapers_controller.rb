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


def get_packages
    scraper = Scraper.new()
    scraper.parse_url(scraper.get_url('https://www.sling.com'))
    file_list = ['scraping/orange.htm', 'scraping/blue.htm', 'scraping/orange_blue.htm']
    index = 0
    packages_list = []
    
    file_list.each do |file|
        all_channels_scraper = Scraper.new()
        all_channels_scraper.parse_url(File.read(file))
        
        cost_list = all_channels_scraper.parse_page.css('.dyn-grid_package-title')
        name_list = all_channels_scraper.parse_page.css('.dyn-grid_package-subtitle')
        
        package_cost_list = cost_list.zip(name_list).map do |cost, package|
            [package.text, cost.text[/[\d]+/]]
        end
        
        count = all_channels_scraper.parse_page.css('#channelList').css('img').count
        channels_list = all_channels_scraper.parse_page.css('#channelList').css('img').map do |image|
            image['title']
        end 
        
        packages_list << [package_cost_list[index][0], channels_list, count, package_cost_list[index][1]]
        index += 1
    end
    packages_list
end


def get_addons
    scraper = Scraper.new()
    scraper.parse_url(scraper.get_url('https://www.sling.com'))
    addon_list = []
    scraper.parse_page.css('//div[@data-sling-tab-name]').each do |category|
        addon_category = category['data-sling-tab-name']
        channels_list = category.css('.carousel-jam_channel-container').css('img').map do |image|
            image['alt']
        end
        cost = category.css('.carousel-jam_heading').text[/[\d]+/]
        addon_list << [addon_category, channels_list, cost]
    end
    addon_list
end

class ScrapersController < ApplicationController
    
    def select_package
    end
    
    def show_package
        if params[:service] == 'sling'
            @packages = get_packages
            @addons = get_addons
        end
    end

end
