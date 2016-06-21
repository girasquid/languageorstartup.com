#!/usr/bin/env ruby

require "open-uri"
require "byebug"
require "nokogiri"

def name_not_unclear_enough(name)
  # Reject startups that have names longer than one 'word',
  # because those are pretty obvious.
  return true if name.split(' ').length > 1
  # Reject startups that have a name with a '.' inside (mobi.tv),
  # because those are clearly tech startups.
  return true if name.include?('.')
  # Reject startups with numbers in their names. No languages have
  # numbers in their names.
  return true if name =~ /\d/
end

URL = "https://en.wikipedia.org/wiki/List_of_Y_Combinator_startups"

document = Nokogiri::HTML(open(URL).read)
# Wikipedia's list page structure keeps the content inside mw-content-text, and
# then the divs that contain content lists have class 'columns'.
query = '//*[@id="mw-content-text"]/div[contains(@class, "columns")]/ul/li'
startups = document.xpath(query).collect(&:text)
startups.reject! {|i| name_not_unclear_enough(i)}
# Lowercase everything so that weirdLyCapitalizedNames don't make it easier.
startups.map!(&:downcase)
puts startups.inspect
