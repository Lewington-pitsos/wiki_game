require 'irbtools'
require 'watir'
require 'nokogiri'

require_relative './rubyscripts/wikiScraper.rb'
require_relative './rubyscripts/archivist.rb'

BR = Watir::Browser.new :firefox

LOGGER = Logger.new('scrape.log')

SCRAPER = WikiScraper.new(BR)

loops_wanted = 100
loops_found = 0

def scrape
  LOGGER.debug("Beginning new scrape...\n\n")
  SCRAPER = WikiScraper.new(BR)
  while loops_wanted < loops_found
    LOGGER.debug("Starting loop #{count + 1}\n")
    SCRAPER.find_wiki_loop()
    loops_wanted += 1
  end
end

begin
  scrape()
rescue
  LOGGER.error <<~MESSAGE
    WARNING: there was a terrible error of some kind. Details:\n\n

    Current page: #{SCRAPER.allPages[-1].url}\n
    Current next page: #{SCRAPER.allPages[-1].nextUrl}\n
    Current @nextUrl: #{SCRAPER.nextUrl} (should be same as above)\n

    Previous page: #{SCRAPER.allPages[-2].url}\n
    Previous next page: #{SCRAPER.allPages[-2].nextUrl}\n\n\n

    Ok, now we'll keep going with a new scraper...\n
    All the data from that last scrape will not be added to the database\n\n\n

  MESSAGE
  scrape()
end
