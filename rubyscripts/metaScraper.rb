require_relative './wikiScraper.rb'

class MetaScraper

  # basically this guy manages the amount of scraping we want to do and automatically handles errors (which we are bound to have given how huge wikipedia is) so that the scrape will reach the specified goal
  # it also does a bit of logging

  attr_accessor :scraper

  def initialize
    @loops_wanted = 200 #arbetrary
    @loops_found = 0
  end

  def scrape
    # starts scraping from a random page with a new scraper instance and continues untill it hits an error or the number of requested scrapes is achieved
    @scraper = WikiScraper.new(BR)
    LOGGER.debug("Beginning new scrape...\n\n")

    while @loops_wanted > @loops_found
      LOGGER.debug("Starting loop #{@loops_found + 1}")
      @scraper.find_wiki_loop()
      @loops_found += 1
    end

    LOGGER.debug("Scraping finished, #{@loops_found} loops have been found")
  end

  def startSafetyScrape
    # starts scraping. If an error is encounted we log an error report and start scraping again.
    begin
      scrape()
    rescue
      logErrorMessage()
      startSafetyScrape()
    end
  end

  def logErrorMessage
    LOGGER.error <<~MESSAGE
      WARNING: there was a terrible error of some kind. Details:\n

      Current page: #{@scraper.currentPage[:url]}
      Current next page: #{@scraper.currentPage[:nextUrl]}

      Previous page: #{@scraper.previousPage[:url]}
      Previous next page: #{@scraper.previousPage[:nextUrl]}\n\n

      Ok, now we'll keep going with a new scraper...
      NO data from that last loop will be added to the database\n\n

    MESSAGE
  end
end
