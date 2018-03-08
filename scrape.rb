require 'irbtools'
require 'watir'
require 'nokogiri'

require_relative './rubyscripts/metaScraper.rb'
require_relative './rubyscripts/archivist.rb'

BR = Watir::Browser.new :firefox

LOGGER = Logger.new('scrape.log')

metaScraper = MetaScraper.new()

metaScraper.startLazyScrape()
