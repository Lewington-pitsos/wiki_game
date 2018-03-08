require_relative './shared/fileHelper'
require_relative './wikiScraper/pageScraper'

class WikiScraper

  attr_accessor :br, :allPages, :currentPage, :previousPage

  include PageScraper
  include FileHelper

  def initialize(br)
    @br = br                            # browser
    @allPages = getAllEntries()         # working model of the saved database
    @currentPage = nil                  # the page being scraped
    @previousPage = nil                 # the previous page
    @redirectedUrls = []                # urls that redirected into pages we
                                        # visited (only record of these)
  end

  def find_wiki_loop
    # visits a random wikipedia and starts continuous page scraping
    @br.goto('https://en.wikipedia.org/wiki/Special:Random')
    scrapeAgain()
  end

  def scrapeAgain
    # scrapes the page (updating the @allPages with a page entry for that page)
    # if the url for the next page is a new url, we recur
    # otherwise we've hit a loop, so we save everything and prepair to find the netx loop

    scrapePage()
    correctUrl()
    if latestPageIsNew?(@currentPage[:nextUrl])
      visitLink(@currentPage[:nextUrl])
      scrapeAgain()
    else
      LOGGER.debug("we found a loop at: #{@currentPage[:title]}\n\n")
      writeToFile(@allPages) # file_helper
      @currentPage = nil
      @previousPage = nil
    end
  end

  def latestPageIsNew?(url)
    # returns a boolean of whether the passed in url matches either any of the already scraped pages in the record hash OR any of the redirected urls we have encountered during this scrape
    !(@allPages[url] ||  @redirectedUrls.include?(url))
  end

  def correctUrl
    # sometimes urls redirect to other pages (eg /wiki/Anciant_Greek_Language >>> /wiki/Ancient_Greek)
    # in such cases we want to change the recorded nextUrl for the previous page to match the url of the actual page we navigated to AND keep a record of the redirected url
    if @previousPage && @currentPage[:url] != @previousPage[:nextUrl]
      LOGGER.debug("Changing #{@previousPage[:nextUrl]} to #{@currentPage[:url]}")
      @redirectedUrls << @previousPage[:nextUrl]
      @previousPage[:nextUrl] = @currentPage[:url]
    end
  end
end
