require 'nokogiri'

html_doc = Nokogiri::HTML(File.read("live-tv"))
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
puts [["Hulu Live TV", channels_list, channels_list.count, price[0]]]
