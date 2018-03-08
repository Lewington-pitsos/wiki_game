require_relative './shared/fileHelper'

class Archivist

  # not very sophisticated, but it lets us do simple things like count how many pages are "upstream" or "downstream" from a given page

  attr_accessor :allPages

  include FileHelper

  def initialize
    @allPages = getAllEntries()
  end

  def getNext(page)
    # returns the page whose url is the same as the nextUrl of this page (should only ever be one)
    @allPages[page[:nextUrl]]
  end

  def getAllFurtherEntries(page)
    # passed in a page page
    # we make an empty array and add the page to the array.
    # we then get the next (linking) page, add it to the array and so on untill we reach an page that is already in the array (in which case we have hit a loop and we return the array)
    array = []

    while !array.include?(page)
      array << page
      page = getNext(page)
    end

    array
  end

  def pointingEntriesCount(page)
    # returns the number of entries that are "upriver" of the current page (of those currently stored in @allPages)

    @allPages.count do |_, candidatePage|
      pointsTo(candidatePage, page)
    end
  end

  def pointingPages(page)
    @allPages.select do |_, candidatePage|
      pointsTo(candidatePage, page)
    end
  end

  def pointsTo(page, otherPage)
    # returns boolean of whether or not the chain of links starting an page ever points to otherPage


    passedPages = []

    while !passedPages.include?(page)
      if page == otherPage
        return true
      else
        passedPages << page
        page = getNext(page)
      end
    end

    false
  end
end



archivist = Archivist.new

puts archivist.allPages

entry =  archivist.allPages["/wiki/Greek_language"]

puts entry

puts archivist.pointingEntriesCount(entry)
