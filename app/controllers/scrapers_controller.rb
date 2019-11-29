require 'watir'
require 'nokogiri'


def get_packages
    index = 0
    packages_list = []
    chrome_bin = ENV.fetch('GOOGLE_CHROME_SHIM', nil)
    browser = Watir::Browser.new(:chrome, {:chromeOptions => {:args => ['--headless', '--window-size=1200x600'], :binary => chrome_bin}})
    
    ["planOne", "planTwo", "planThree"].each do |package|
        browser.goto('https://www.sling.com/')
        browser.a(:id => package).fire_event :click
        html_doc = Nokogiri::HTML(browser.html)
        
        cost_list = html_doc.css('.dyn-grid_package-title')
        name_list = html_doc.css('.dyn-grid_package-subtitle')
        
        package_cost_list = cost_list.zip(name_list).map do |cost, package|
            [package.text, cost.text[/[\d]+/]]
        end
        
        count = html_doc.css('#channelList').css('img').count
        channels_list = html_doc.css('#channelList').css('img').map do |channel|
            channel['title']
        end
        
        packages_list << [package_cost_list[index][0], channels_list, count, package_cost_list[index][1]]
        index += 1
    end
    
    packages_list
end


def get_addons
    chrome_bin = ENV.fetch('GOOGLE_CHROME_SHIM', nil)
    browser = Watir::Browser.new(:chrome, {:chromeOptions => {:args => ['--headless', '--window-size=1200x600'], :binary => chrome_bin}})
    browser.goto('https://www.sling.com/')
    html_doc = Nokogiri::HTML(browser.html)
    
    addon_list = []
    html_doc.css('//div[@data-sling-tab-name]').each do |category|
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
