module PageScraper
  WIKI_BASE_ROUTE = 'https://en.wikipedia.org'

  # First Link Selector selects
    # all children of the node with class mw-parser-output
    # that have the name of a
    # that have no ancestor which is a table
    # and no ancestor which has the class of hatnote
    # AND no ancestor which has the class of thumb
    # and which don't start with a '[' (those links are references)
    # and the link isn't inside an IPA span (for like, phonetic stuff)
    # and the link isn't inside a haudio span (for audio files)
    # and has a href that starts with '/wiki' (this probably makes a lot of the others redundant)

  FLS = "//*[@class='mw-parser-output']//a[not(ancestor::table|ancestor::*[contains(@class, 'hatnote')]|ancestor::*[contains(@class, 'thumb')]|ancestor::*[contains(@class, 'IPA')]|ancestor::*[contains(@class, 'haudio')])][not(starts-with(text(), '['))][not(contains(@class, 'image'))][starts-with(@href, '/wiki')]"


  def scrapePage
    # expects to be passed in a Watir:Browser object
    # gets the header from the current browser page and records it, the page url and the next page's url to the array
    # sets the @nextUrl attr variable to the next pag's url
    page = getPage
    nextPageUrl =  getFirstLinkUrl(page)
    entry = getPageRecord(page, nextPageUrl)
    recordEntry(entry)
    @nextUrl =  nextPageUrl

    LOGGER.debug("Information scraped from: #{entry[:url]}")
  end


  def getPage
    # returns the parsed html of the passed in browser object
    Nokogiri::HTML(@br.html)
  end

  def getFirstLinkUrl(page)
    link = getFirstLink(page)
    link.attribute('href').value
  end

  def getFirstLink(page)
    page.xpath(FLS)[0]
  end

  def getPageRecord(page, nextUrl)
    # returns the header, page url ending and passed in nextUrl in an object
    header = getHeader(page)
    url = urlEnding(@br.url)
    {title: header, url: url, nextUrl: nextUrl}
  end

  def getHeader(page)
    page.css("#firstHeading").text
  end

  def recordEntry(entry)
    @allPages << entry
  end

  def visitLink(path)
    # takes a Nokogiri Element, and nagivgates to the wikipedia page corresponding to it's href attributes
    @br.goto(WIKI_BASE_ROUTE + path)
  end

  def urlEnding(url)
    url.gsub(WIKI_BASE_ROUTE, '')
  end
end
