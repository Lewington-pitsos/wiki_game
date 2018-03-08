require_relative './shared/fileHelper'
require_relative './wikiScraper/pageScraper'

class WikiScraper

  attr_accessor :br, :allPages

  include PageScraper
  include FileHelper

  def initialize(br)
    @br = br
    @allPages = getAllEntries()
  end

  def find_wiki_loop
    # visits a random wikipedia page defines a new empty array and starts continuous page scraping
    @br.goto('https://en.wikipedia.org/wiki/Special:Random')
    scrapeAgain()
  end

  def scrapeAgain
    # first ensures that the current url matches the one we just came from
    # scrapes the page (updating the @allPages with a page entry for that page)
    # if the url for the next page is a new url, we recur
    # otherwise we save the @allPages to the record file
    scrapePage()
    correctUrl()
    if latestTitleIsNew?()
      visitLink(nextUrl())
      scrapeAgain()
    else
      LOGGER.debug("we found a loop at: #{@allPages[-1][:title]}\n\n")
      writeToFile(@allPages) # file_helper
    end
  end

  def latestTitleIsNew?
    # to prevent loops where the same page keeps snedin us to itself through a redirect
    !(@allPages.map{ |page| page[:url] }.include?(nextUrl()) ||
      nextUrl == previousNextUrl)
  end

  def nextUrl
    @allPages[-1][:nextUrl]
  end

  def previousNextUrl
    @allPages[-2][:nextUrl]
  end

  def correctUrl
    # sometimes urls redirect to different pages,
    # in such cases we want to change the recorded nextUrl for the previous page to match the actual page we navigated to
    url = urlEnding(@br.url)
    if url != previousNextUrl()
      @allPages[-2][:nextUrl] = url
    end
  end
end
