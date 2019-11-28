require 'watir'
require 'nokogiri'

browser = Watir::Browser.new(:chrome, {:chromeOptions => {:args => ['--headless', '--window-size=1200x600'], :binary => '/usr/bin/google-chrome'}})
browser.goto('https://tv.youtube.com/welcome')
browser.element(tag_name: "article", class: "ytv-surface__content").wait_until(&:present?).div(class: ["js-input", "input"]).wait_until(&:present?)
browser.text_field(aria_label: "Enter your home ZIP code").set('77840')
browser.button(class: ["js-input-button", "input__submit-button", "ytv-button"]).click
html_doc = Nokogiri::HTML(browser.html)
puts html_doc
