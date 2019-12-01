require 'watir'
require 'nokogiri'

# browser = Watir::Browser.new(:chrome, {:chromeOptions => {:args => ['--headless', '--window-size=1200x600'], :binary => '/usr/bin/google-chrome'}})
# browser.goto('https://tv.youtube.com/welcome')
# browser.element(tag_name: "article", class: "ytv-surface__content").wait_until(&:present?).div(class: ["js-input", "input"]).wait_until(&:present?)
# browser.text_field(aria_label: "Enter your home ZIP code").set('77840')
# browser.button(class: ["js-input-button", "input__submit-button", "ytv-button"]).click
# html_doc = Nokogiri::HTML(browser.html)
# puts html_doc

module Youtube

def get_packages
    browser = Watir::Browser.new(:chrome, {:chromeOptions => {:args => ['--headless', '--window-size=1200x600'], :binary => '/usr/bin/google-chrome'}})
    browser.goto('https://tv.youtube.com/welcome')
    browser.a(class: ["ytv-link", "js-click"]).click
    html_doc = Nokogiri::HTML(browser.html)
    
    channels_list = html_doc.css('div.zip__network').map do |channel|
        channel.css('p').text
    end
    
    price = html_doc.css('span.price').text[/[\d]+[,.][\d]+/]
    
    ["Youtube TV", channels_list, channels_list.count, price]
end

# puts get_packages



def get_packages_local
    html_doc = Nokogiri::HTML(File.read("youtube.html"))
    
    channels_list = html_doc.css('div.zip__network').map do |channel|
        channel.css('p').text
    end
    
    price = html_doc.css('span.price').text[/[\d]+[,.][\d]+/]
    
    ["Youtube TV", channels_list, channels_list.count, price]
end

end

# puts get_packages_local

