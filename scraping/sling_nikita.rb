require 'open-uri'
require 'nokogiri'
require 'json'
require 'httparty'
require 'watir'


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
    href_list = ["#dyn-grid-plan-tab-1-m-1", "#dyn-grid-plan-tab-2-s-2", "#dyn-grid-plan-tab-3-y-1"]
    index = 0
    packages_list = []

    browser = Watir::Browser.new(:chrome, {:chromeOptions => {:args => ['--headless', '--window-size=1200x600'], :binary => '/usr/bin/google-chrome'}})
    browser.goto('https://www.sling.com/')
    
    href_list.each do |href|
       
        browser.link(href: href).click
	    html_doc = Nokogiri::HTML(browser.html)

        cost_list = html_doc.css('.dyn-grid_package-title')
	    name_list = html_doc.css('.dyn-grid_package-subtitle')
        
        package_cost_list = cost_list.zip(name_list).map do |cost, package|
            [package.text, cost.text[/[\d]+/]]
        end
        
	    count = html_doc.css('div#channelList').css('img').count
	    channels_list = html_doc.css('div#channelList').css('img').map do |image|
            image['title']
        end
        
	    # To test this in isolation uncomment this and also the function call below
        # puts channels_list	
        
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


puts get_packages

# require 'watir'
# require 'nokogiri'
# browser = Watir::Browser.new(:chrome, {:chromeOptions => {:args => ['--headless', '--window-size=1200x600'], :binary => '/usr/bin/google-chrome'}})
# browser.goto('https://www.sling.com/')
# html_doc = Nokogiri::HTML(browser.html)
# channel_list = html_doc.css('li')
# puts channel_list.count
# channel_list.each do |image|
#     puts image['title']
# end
