require_relative './shared/fileHelper'
require_relative './wikiScraper/pageScraper'

class WikiScraper

  attr_accessor :br, :allPages, :currentPage, :previousPage

  include PageScraper
  include FileHelper

  def initialize(br)
    @br = br
    @allPages = getAllEntries()
    @currentPage = nil
    @previousPage = nil
    @redirectedUrls = []
  end

  def find_wiki_loop
    # visits a random wikipedia page defines a new empty array and starts continuous page scraping
    @br.goto('https://en.wikipedia.org/wiki/Special:Random')
    scrapeAgain()
  end

  def scrapeAgain
    # scrapes the page (updating the @allPages with a page entry for that page)
    # if the url for the next page is a new url, we recur
    # otherwise we save the @allPages to the record file

    # either way we ensure that the current url matches the one we just came from, and correct the previous next url if it doesn't (unless this is the first round for scraping this loop, in which case there should be a disconnect)
    scrapePage()
    correctUrl()
    if latestPageIsNew?(@currentPage[:nextUrl])
      visitLink(@currentPage[:nextUrl])
      scrapeAgain()
    else
      @currentPage = nil
      @previousPage = nil
      LOGGER.debug("we found a loop at: #{@currentPage[:title]}\n\n")
      writeToFile(@allPages) # file_helper
    end
  end

  def latestPageIsNew?(url)
    # returns a boolean of whether the passed in url matches either any of the already scraped pages in the record hash OR any of the redirected urls we have encountered during this scrape
    !(@allPages[url] ||  @redirectedUrls.include?(url))
  end

  def correctUrl
    # sometimes urls redirect to different pages
    # in such cases we want to change the recorded nextUrl for the previous page to match the url of the actual page we navigated to AND keep a record of the redirected url
    if @previousPage && @currentPage[:url] != @previousPage[:nextUrl]
      LOGGER.debug("Changing #{@previousPage[:nextUrl]} to #{@currentPage[:url]}")
      @redirectedUrls << @previousPage[:nextUrl]
      @previousPage[:nextUrl] = @currentPage[:url]
    end
  end
end
