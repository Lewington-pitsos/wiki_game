require 'irbtools'
require 'watir'
require 'nokogiri'
require 'yaml'

require_relative './wikiScraper.rb'

BR = Watir::Browser.new :firefox

SCRAPER = WikiScraper.new(BR)

10.times do
  SCRAPER.find_wiki_loop
end
