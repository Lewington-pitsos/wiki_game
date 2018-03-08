require_relative './wikiScraper.rb'

class MetaScraper

  attr_accessor :scraper

  def initialize
    @loops_wanted = 100
    @loops_found = 0
  end

  def scrape
    # starts scraping from a random page with a new scraper instance and continues untill it hits an error or the number of requested scrapes is achieved
    @scraper = WikiScraper.new(BR)
    LOGGER.debug("Beginning new scrape...\n\n")
    while @loops_wanted > @loops_found
      LOGGER.debug("Starting loop #{@loops_found + 1}\n")
      @scraper.find_wiki_loop()
      @loops_found += 1
    end

    LOGGER.debug("Scraping finished, #{@loops_found} loops have been found")
  end

  def startLazyScrape
    # starts scraping. If an error is encounted we log an error report and start scraping again.
    begin
      scrape()
    rescue
      logErrorMessage
      startLazyScrape
    end
  end

  def logErrorMessage
    LOGGER.error <<~MESSAGE
      WARNING: there was a terrible error of some kind. Details:\n

      Current page: #{@scraper.allPages[-1][:url]}
      Current next page: #{@scraper.allPages[-1][:nextUrl]}
      Current @nextUrl: #{@scraper.nextUrl} (should be same as above)

      Previous page: #{@scraper.allPages[-2][:url]}
      Previous next page: #{@scraper.allPages[-2][:nextUrl]}\n\n

      Ok, now we'll keep going with a new scraper...
      NO data from that last loop will be added to the database\n\n

    MESSAGE
  end
end
