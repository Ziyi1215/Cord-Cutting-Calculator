require 'watir'
require 'nokogiri'

module Att

def get_packages
    browser = Watir::Browser.new(:chrome, {:chromeOptions => {:args => ['--headless', '--window-size=1200x600'], :binary => '/usr/bin/google-chrome'}})
    browser.goto('https://www.atttvnow.com/')
    browser.a(id: "BasePackageTablink").click
    html_doc = Nokogiri::HTML(browser.html)
    
    packages_list = []
    
    plus_cost = html_doc.css('div#plus-info').css('div.price').text[/[\d]+/]
    plus_channels = html_doc.css('div.plus-images').css('img').map do |channel|
        channel['src'].scan(/.+\/([a-zA-Z]+).png/)
    end
    plus_channels = plus_channels.uniq
    plus_count = plus_channels.count
    packages_list << ["PLUS", plus_channels, plus_count, plus_cost]
    
    
    max_cost = html_doc.css('div#max-info').css('div.price').text[/[\d]+/]
    max_channels = html_doc.css('div.max-images').css('img').map do |channel|
        channel['src'].scan(/.+\/([a-zA-Z]+).png/)
    end
    max_channels = max_channels.uniq
    max_count = max_channels.count
    packages_list << ["MAX", max_channels, max_count, max_cost]
    
    packages_list
end

# puts get_packages


def get_packages_local
    html_doc = Nokogiri::HTML(File.read("att.html"))
    
    packages_list = []
    
    plus_cost = html_doc.css('div#plus-info').css('div.price').text[/[\d]+/]
    plus_channels = html_doc.css('div.plus-images').css('img').map do |channel|
        channel['src'].scan(/.+\/([a-zA-Z]+).png/)
    end
    plus_channels = plus_channels.uniq
    plus_count = plus_channels.count
    packages_list << ["PLUS", plus_channels, plus_count, plus_cost]
    
    
    max_cost = html_doc.css('div#max-info').css('div.price').text[/[\d]+/]
    max_channels = html_doc.css('div.max-images').css('img').map do |channel|
        channel['src'].scan(/.+\/([a-zA-Z]+).png/)
    end
    max_channels = max_channels.uniq
    max_count = max_channels.count
    packages_list << ["MAX", max_channels, max_count, max_cost]
    
    packages_list
end

# puts get_packages_local

end

# browser = Watir::Browser.new(:chrome, {:chromeOptions => {:args => ['--headless', '--window-size=1200x600'], :binary => '/usr/bin/google-chrome'}})
# browser.goto('https://www.atttvnow.com/')
# browser.a(id: "InternationalPackageTablink").div(class: "intpack-text").click
# html_doc = Nokogiri::HTML(browser.html)
# puts html_doc
