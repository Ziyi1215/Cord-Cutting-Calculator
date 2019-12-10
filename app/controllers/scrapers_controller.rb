require 'watir'
require 'nokogiri'

def get_packages_local_sling
    index = 0
    packages_list = []

    ["scraping/orange.html", "scraping/blue.html", "scraping/orange_blue.html"].each do |package|
        
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

def get_packages_sling
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
    
    browser.close
    
    packages_list
end


def get_addons_local_sling
    html_doc = Nokogiri::HTML(File.read("scraping/orange.html"))
    
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


def get_addons_sling
    chrome_bin = ENV.fetch('GOOGLE_CHROME_SHIM', nil)
    browser = Watir::Browser.new(:chrome, {:chromeOptions => {:args => ['--headless', '--window-size=1200x600'], :binary => chrome_bin}})
    browser.goto('https://www.sling.com/')
    html_doc = Nokogiri::HTML(browser.html)
    browser.close
    
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


def get_packages_local_att
    html_doc = Nokogiri::HTML(File.read("scraping/att.html"))
    
    packages_list = []
    
    plus_cost = html_doc.css('div#plus-info').css('div.price').text[/[\d]+/]
    plus_channels = html_doc.css('div.plus-images').css('img').map do |channel|
        channel['src'].scan(/.+\/([a-zA-Z]+).png/)[0]
    end
    plus_channels = plus_channels.compact
    plus_channels = plus_channels.map do |channel|
        channel[0]
    end
    plus_channels = plus_channels.uniq
    plus_count = plus_channels.count
    packages_list << ["AT&T PLUS", plus_channels, plus_count, plus_cost]
    
    
    max_cost = html_doc.css('div#max-info').css('div.price').text[/[\d]+/]
    max_channels = html_doc.css('div.max-images').css('img').map do |channel|
        channel['src'].scan(/.+\/([a-zA-Z]+).png/)[0]
    end
    max_channels = max_channels.compact
    max_channels = max_channels.map do |channel|
        channel[0]
    end
    max_channels = max_channels.uniq
    max_count = max_channels.count
    packages_list << ["AT&T MAX", max_channels, max_count, max_cost]
    
    packages_list
end



def get_packages_att
    chrome_bin = ENV.fetch('GOOGLE_CHROME_SHIM', nil)
    browser = Watir::Browser.new(:chrome, {:chromeOptions => {:args => ['--headless', '--window-size=1200x600'], :binary => chrome_bin}})
    browser.goto('https://www.atttvnow.com/')
    html_doc = Nokogiri::HTML(browser.html)
    browser.close
    
    packages_list = []
    
    plus_cost = html_doc.css('div#plus-info').css('div.price').text[/[\d]+/]
    plus_channels = html_doc.css('div.plus-images').css('img').map do |channel|
        channel['src'].scan(/.+\/([a-zA-Z]+).png/)[0]
    end
    plus_channels = plus_channels.compact
    plus_channels = plus_channels.map do |channel|
        channel[0]
    end
    plus_channels = plus_channels.uniq
    plus_count = plus_channels.count
    packages_list << ["PLUS", plus_channels, plus_count, plus_cost]
    
    
    max_cost = html_doc.css('div#max-info').css('div.price').text[/[\d]+/]
    max_channels = html_doc.css('div.max-images').css('img').map do |channel|
        channel['src'].scan(/.+\/([a-zA-Z]+).png/)[0]
    end
    max_channels = max_channels.compact
    max_channels = max_channels.map do |channel|
        channel[0]
    end
    max_channels = max_channels.uniq
    max_count = max_channels.count
    packages_list << ["MAX", max_channels, max_count, max_cost]
    
    packages_list
end


def get_packages_local_youtube
    html_doc = Nokogiri::HTML(File.read("scraping/youtube.html"))
    
    channels_list = html_doc.css('div.zip__network').map do |channel|
        channel.css('p').text
    end
    
    price = html_doc.css('span.price').text[/[\d]+[,.][\d]+/]
    
    [["Youtube TV", channels_list, channels_list.count, price]]
end


def get_packages_youtube
    chrome_bin = ENV.fetch('GOOGLE_CHROME_SHIM', nil)
    browser = Watir::Browser.new(:chrome, {:chromeOptions => {:args => ['--headless', '--window-size=1200x600'], :binary => chrome_bin}})
    browser.goto('https://tv.youtube.com/welcome')
    browser.a(class: ["ytv-link", "js-click"]).click
    html_doc = Nokogiri::HTML(browser.html)
    browser.close
    
    channels_list = html_doc.css('div.zip__network').map do |channel|
        channel.css('p').text
    end
    
    price = html_doc.css('span.price').text[/[\d]+[,.][\d]+/]
    
    [["Youtube TV", channels_list, channels_list.count, price]]
end


def get_packages_local_hulu
	html_doc = Nokogiri::HTML(File.read("scraping/live-tv"))
	channels_list = html_doc.css('img').map do |image|
							class_icon = image['class']
							network_icon = 'network-icon ls-is-cached lazyloaded'
							network_icon1 = 'network-icon lazyload'
							if class_icon.to_s == network_icon.to_s || class_icon.to_s == network_icon1.to_s
									image['alt']
							end
			end

	req_icon_pricing =  'jsx-3636485725 plan-card__priceline'
	price = html_doc.css("div").map do |divisions|
					class_icon = divisions['class']
					if class_icon.to_s == req_icon_pricing.to_s
							divisions.css('p').map do |addons|
									class_icon = addons['class']
									req_icon_price = 'jsx-3636485725 plan-card__amount'
									if class_icon.to_s == req_icon_price.to_s
													addons.text
									end
							end
					end
		end
	channels_list.delete(nil)
	price.delete(nil)
	[["Hulu Live TV", channels_list, channels_list.count, price[0][0].scan(/[\d]+[,.][\d]+/)[0]]]
end


def get_packages_hulu
    chrome_bin = ENV.fetch('GOOGLE_CHROME_SHIM', nil)
	browser = Watir::Browser.new(:chrome, {:chromeOptions => {:args => ['--headless', '--window-size=1200x600'], :binary => chrome_bin}})
    browser.goto('https://www.hulu.com/live-tv')
    html_doc = Nokogiri::HTML(browser.html)
    browser.close
	channels_list = html_doc.css('img').map do |image|
							class_icon = image['class']
							network_icon = 'network-icon ls-is-cached lazyloaded'
							network_icon1 = 'network-icon lazyload'
							if class_icon.to_s == network_icon.to_s || class_icon.to_s == network_icon1.to_s
									image['alt']
							end
			end

	req_icon_pricing =  'jsx-3636485725 plan-card__priceline'
	price = html_doc.css("div").map do |divisions|
					class_icon = divisions['class']
					if class_icon.to_s == req_icon_pricing.to_s
							divisions.css('p').map do |addons|
									class_icon = addons['class']
									req_icon_price = 'jsx-3636485725 plan-card__amount'
									if class_icon.to_s == req_icon_price.to_s
													addons.text
									end
							end
					end
		end
	channels_list.delete(nil)
	price.delete(nil)
	[["Hulu Live TV", channels_list, channels_list.count, price[0][0].scan(/[\d]+[,.][\d]+/)[0]]]
end


class ScrapersController < ApplicationController
    def select_package
    end
    
    def show_package
        if params[:service] == "sling"
            @addons = get_addons_local_sling
            @packages = get_packages_local_sling
        elsif params[:service] == "att"
            @packages = get_packages_local_att
        elsif params[:service] == "youtube" 
            @packages = get_packages_local_youtube
        elsif params[:service] == "hulu"
	        @packages = get_packages_local_hulu
        end
        
    
        
        if request.post?
            if !params["package_info"].nil?
                @packages.each do |package_name, channels_list_local, count, cost1|
                    
                	channels_list_local.each do |c|
				        Channel.find_or_create_by(name: c.downcase)
				    end
			    
                    # Package.find_or_create_by(name: package_name.downcase, cost: cost1)
                    
                    @my_channel = Package.where(name: package_name.downcase)
				    if @my_channel.blank?
				        Package.create(name: package_name.downcase, cost: cost1)
				    else
				        @my_channel.first.update_attributes(cost: cost1)
				    end
                    
			        package_id1 = Package.where(name: package_name.downcase).pluck(:id)[0]
			        
                    channel_id_list_local = channels_list_local.map do |c|
				        Channel.where(name: c.downcase).pluck(:id)[0]
                    end
			
			        ProvideChannel.create_record(package_id1, channel_id_list_local)
                end
                session[:update_notice] = "Package information updated"
            end
        end
    end
end
