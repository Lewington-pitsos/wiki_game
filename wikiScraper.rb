require_relative './wikiScraper/fileHelper'
require_relative './wikiScraper/pageScraper'

class WikiScraper

  include PageScraper
  include FileHelper

  def initialize(br)
    @br = br
  end

  def find_wiki_loop
    # visits a random wikipedia page defines a new empty array and starts continuous page scraping
    @br.goto('https://en.wikipedia.org/wiki/Special:Random')
    array = []
    scrapeAgain(array)
  end

  def scrapeAgain(array)
    # scrapes the page (updating the array with the page's title)
    # if the title is a new title, we recur
    # otherwise we save the whole array of titles to the record file
    scrapePage(@br, array) # page_scraper
    if latestTitleIsNew?(array)
      scrapeAgain(array)
    else
      puts "we found a loop at: #{array[0]['title']}"
      saveTitleArray(array) # file_helper
    end
  end

  def latestTitleIsNew?(array)
    !array[0.. -2].include?(array[-1])
  end

end
