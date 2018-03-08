require 'irbtools'
require 'watir'
require 'nokogiri'
require 'headless'

require_relative './rubyscripts/metaScraper.rb'
# require_relative './rubyscripts/archivist.rb'

headless = Headless.new
headless.start

BR = Watir::Browser.new :firefox

LOGGER = Logger.new('scrape.log')

metaScraper = MetaScraper.new()

metaScraper.scrape()
