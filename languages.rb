#!/usr/bin/env ruby

require "open-uri"
require "byebug"
require "nokogiri"

def name_not_unclear_enough(name)
  # Reject languages that have names longer than one 'word',
  # because those are pretty obvious.
  return true if name.split(' ').length > 1
  # Non-ASCII names are decent giveaways that something is a language.
  return true unless name.ascii_only?
end

URL = "https://en.wikipedia.org/wiki/List_of_language_names"

document = Nokogiri::HTML(open(URL).read)
# Wikipedia's list page structure keeps the content inside mw-content-text, and
# then the divs that contain content lists have class 'columns'.
query = '//*[@id="mw-content-text"]/p/b/a'
languages = document.xpath(query).collect(&:text)
languages.reject! {|i| name_not_unclear_enough(i)}
# Lowercase everything so that weirdLyCapitalizedNames don't make it easier.
languages.map!(&:downcase)
puts languages.inspect
