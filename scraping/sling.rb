require 'watir'
require 'nokogiri'

module Sling
    
def get_packages
    index = 0
    packages_list = []
    browser = Watir::Browser.new(:chrome, {:chromeOptions => {:args => ['--headless', '--window-size=1200x600'], :binary => '/usr/bin/google-chrome'}})
    
    ["planOne", "planTwo", "planThree"].each do |package|
        browser.goto('https://www.sling.com/')
        browser.a(:id => package).fire_event :click
        html_doc = Nokogiri::HTML(browser.html)
        
        cost_list = html_doc.css('.dyn-grid_package-title')
        name_list = html_doc.css('.dyn-grid_package-subtitle')
        
        package_cost_list = cost_list.zip(name_list).map do |cost, pack|
            [pack.text, cost.text[/[\d]+/]]
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

# puts get_packages


def get_addons
    browser = Watir::Browser.new(:chrome, {:chromeOptions => {:args => ['--headless', '--window-size=1200x600'], :binary => '/usr/bin/google-chrome'}})
    browser.goto('https://www.sling.com/')
    html_doc = Nokogiri::HTML(browser.html)
    
    addon_list = []
    html_doc.css('//div[@data-sling-tab-name]').each do |category|
        addon_category = category['data-sling-tab-name']
        channels_list = category.css('.carousel-jam_channel-container').css('img').map do |image|
            image['alt']
        end
        cost = category.css('.carousel-jam_heading').text[/[\d]+/]
        count = channels_list.count
        addon_list << [addon_category, channels_list, count, cost]
    end
    
    addon_list
end

# puts get_addons




def get_packages_local
    index = 0
    packages_list = []

    ["orange.html", "blue.html", "orange_blue.html"].each do |package|
        
        html_doc = Nokogiri::HTML(File.read(package))
        
        cost_list = html_doc.css('.dyn-grid_package-title')
        name_list = html_doc.css('.dyn-grid_package-subtitle')
        
        package_cost_list = cost_list.zip(name_list).map do |cost, pack|
            [pack.text, cost.text[/[\d]+/]]
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

# puts get_packages_local


def get_addons_local
    html_doc = Nokogiri::HTML(File.read("orange.html"))
    
    addon_list = []
    html_doc.css('//div[@data-sling-tab-name]').each do |category|
        addon_category = category['data-sling-tab-name']
        channels_list = category.css('.carousel-jam_channel-container').css('img').map do |image|
            image['alt']
        end
        cost = category.css('.carousel-jam_heading').text[/[\d]+/]
        count = channels_list.count
        addon_list << [addon_category, channels_list, count, cost]
    end
    
    addon_list
end

# puts get_addons_local
end