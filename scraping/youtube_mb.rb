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
    href_list = [".zip__networks-entity"]
    index = 0
    packages_list = []

    browser = Watir::Browser.new(:chrome, {:chromeOptions => {:args => ['--headless', '--window-size=1200x600'], :binary => '/usr/bin/google-chrome'}})
    browser.goto('https://tv.youtube.com/welcome/')
    
    href_list.each do |href|
       
        browser.link(href: href).click
	    html_doc = Nokogiri::HTML(browser.html)

        # Goes into the .zip_network class and inside the p tag which gives us the name
	    channels_list = html_doc.css('.zip__network').map do |channelName|
            channelName['p']
        end
        
	    # To test this in isolation uncomment this and also the function call below
        # puts channels_list	
        
        packages_list << [package_cost_list[index][0], channels_list]
        index += 1
    end
    
    packages_list
end



puts get_packages
