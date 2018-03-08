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

  FLS = "//*[@class='mw-parser-output']//a[not(ancestor::table|ancestor::*[contains(@class, 'hatnote')]|ancestor::*[contains(@class, 'thumb')]|ancestor::*[contains(@class, 'IPA')]|ancestor::*[contains(@class, 'haudio')])][not(starts-with(text(), '['))]"

  def scrapePage(br, array)
    # expects to be passed in an array and a Watir:Browser object
    # gets the header from the current browser page, saves it and the page url to the array and navigates the browser to the first link of the current page
    page = getPage(br)
    nextPageUrl =  getFirstLinkUrl(page)
    array << getPageRecord(page, br, nextPageUrl)
    visitLink(br, nextPageUrl)

    puts array[-1]
  end

  def getPage(br)
    # returns the parsed html of the passed in browser object
    Nokogiri::HTML(br.html)
  end

  def getFirstLinkUrl(page)
    link = getFirstLink(page)
    link.attribute('href').value
  end

  def getFirstLink(page)
    page.xpath(FLS)[0]
  end

  def getPageRecord(page, br, nextUrl)
    # returns the header, page url ending and passed in nextUrl in an object
    header = getHeader(page)
    url = br.url.gsub(WIKI_BASE_ROUTE, '')
    {title: header, url: url, nextUrl: nextUrl}
  end

  def getHeader(page)
    page.css("#firstHeading").text
  end

  def visitLink(br, path)
    # takes a Nokogiri Element, and nagivgates to the wikipedia page corresponding to it's href attributes
    br.goto(WIKI_BASE_ROUTE + path)
  end
end
