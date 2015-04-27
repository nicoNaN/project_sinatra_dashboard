require 'mechanize'
require 'csv'
require 'date'

Weather = Struct.new(:date, :temp_high, :temp_low, :description)

forecast = []

scraper = Mechanize.new do |agent|
  agent.user_agent_alias = 'Mac Safari'
  agent.history_added = Proc.new { sleep 0.5 } # just in case
end

scraper.get('http://www.wunderground.com/US/CA/Santa_Clara.html') do |page|

  calendar_page =   page.links_with(href: /history\/airport/)[0].click

  calendar_page.search('.day').each do |day|

    current_day = Weather.new

    current_day.date = day.search('.dateText').text.strip
    current_day.description = day.search('.show-for-large-up').text.strip
    current_day.temp_high = day.search('.high')[0].text.strip
    current_day.temp_low = day.search('.low')[0].text.strip

    forecast << current_day

  end

  future_days = []
  ten_day = []

  forecast.each do |day|
    if day.date.to_i >= Date.today.day
      future_days << day
    end
  end

  future_days.first(10).map { |day| ten_day << day }

end
