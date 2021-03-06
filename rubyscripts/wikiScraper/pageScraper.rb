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

  FLS = "//*[@class='mw-parser-output']//a" +
          # all <a> elements children of .mw-parser-output elements

          "[not(ancestor::table|ancestor::*[contains(@class, 'hatnote')]|ancestor::*[contains(@class, 'thumb')]|ancestor::*[contains(@class, 'IPA')]|ancestor::*[contains(@class, 'haudio')]|ancestor::*[@id='coordinates'])]" +
          # that are not descendants of
          # => class hatnote elments (paragraphs floating above text body)
          # => class thumb elements ( floating thumbnail holders)
          # => class IPA elemnts (pronounciation)
          # => class haduo elements (links to audio files)
          # => id coordinates elements (containing geographic coordinates)

          "[not(starts-with(text(), '['))]" +
          # whose text content doesn't start with "[" (footnotes)

          "[not(contains(@class, 'image'))]" +
          # whose class list does not contain "image"

          "[starts-with(@href, '/wiki')]"
          # whose link starts with '/wiki'

  def scrapePage
    # expects to be passed in a Watir:Browser object
    # gets the header from the current browser page and records it, the page url and the next page's url to the array
    pageDoc = getPage
    nextPageUrl = getFirstLinkUrl(pageDoc)
    pageEntry = getPageRecord(pageDoc, nextPageUrl)
    recordEntry(pageEntry)

    LOGGER.debug("Information scraped from: #{pageEntry[:url]}")
  end

  def getPage
    # returns the parsed html of the passed in browser object
    Nokogiri::HTML(@br.html)
  end

  def getFirstLinkUrl(page)
    link = getFirstLink(page)
    link.attribute('href').value
  end

  def getFirstLink(pageDoc)
    pageDoc.xpath(FLS)[0]
  end

  def getPageRecord(pageDoc, nextUrl)
    # returns the header, page url ending and passed in nextUrl in an object
    header = getHeader(pageDoc)
    url = urlEnding(@br.url)
    {title: header, url: url, nextUrl: nextUrl}
  end

  def getHeader(page)
    page.css("#firstHeading").text
  end

  def recordEntry(page)
    updateTrackedPages(page)
    # all pages should have unique urls
    @allPages[page[:url]] = page
  end

  def updateTrackedPages(page)
    @previousPage = @currentPage
    @currentPage = page
  end

  def visitLink(path)
    # takes a Nokogiri Element, and nagivgates to the wikipedia page corresponding to it's href attributes
    @br.goto(WIKI_BASE_ROUTE + path)
  end

  def urlEnding(url)
    url.gsub(WIKI_BASE_ROUTE, '')
  end
end
