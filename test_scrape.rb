require 'irbtools'
require 'watir'
require 'nokogiri'

BR = Watir::Browser.new :firefox

FLS = "//*[@class='mw-parser-output']//a[not(ancestor::table|ancestor::*[contains(@class, 'hatnote')]|ancestor::*[contains(@class, 'thumb')]|ancestor::*[contains(@class, 'IPA')]|ancestor::*[contains(@class, 'haudio')]|ancestor::*[@id='coordinates'])][not(starts-with(text(), '['))][not(contains(@class, 'image'))][starts-with(@href, '/wiki')]"

def getPage
  # returns the parsed html of the passed in browser object
  Nokogiri::HTML(@br.html)
end


def getFirstLink(pageDoc)
  pageDoc.xpath(FLS)[0]
end
