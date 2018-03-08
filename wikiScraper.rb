require_relative './wikiScraper/fileHelper'
require_relative './wikiScraper/pageScraper'

class WikiScraper

  attr_accessor :nextUrl, :br, :allPages

  include PageScraper
  include FileHelper

  def initialize(br)
    @br = br
    @nextUrl = nil
    @allPages = getAllEntries()
  end

  def find_wiki_loop
    # visits a random wikipedia page defines a new empty array and starts continuous page scraping
    @br.goto('https://en.wikipedia.org/wiki/Special:Random')
    scrapeAgain()
  end

  def scrapeAgain
    # scrapes the page (updating the array with the page's title)
    # if the title is a new title, we recur
    # otherwise we save the whole array of titles to the record file
    scrapePage(@br) # page_scraper
    if latestTitleIsNew?()
      scrapeNextPage(@br)
    else
      puts "we found a loop at: #{@allPages[-1][:title]}"
      writeToFile(@allPages) # file_helper
    end
  end

  def latestTitleIsNew?
    !@allPages.map{ |page| page[:url] }.include?(@nextUrl)
  end

  def scrapePage(br)
    # expects to be passed in a Watir:Browser object
    # gets the header from the current browser page and records it, the page url and the next page's url to the array
    # sets the @nextUrl attr variable to the next pag's url
    page = getPage(br)
    nextPageUrl =  getFirstLinkUrl(page)
    entry = getPageRecord(page, br, nextPageUrl)
    recordEntry(entry)
    @nextUrl =  nextPageUrl

    puts entry
  end

  def recordEntry(entry)
    @allPages << entry
  end

  def scrapeNextPage(br)
    visitLink(br, @nextUrl)
    scrapeAgain()
  end
end
