require_relative './shared/fileHelper'

class Archivist

  attr_accessor :allPages

  include FileHelper

  def initialize
    @allPages = getAllEntries()
  end

  def getNext(page)
    # returns the entry whose url is the same as the nextUrl of this entry (should only ever be one)
    @allPages[page[:nextUrl]]
  end

  def getAllFurtherEntries(entry)
    # passed in a page entry
    # we make an empty array and add the entry to the array.
    # we then get the next (linking) entry, add it to the array and so on untill we reach an entry that is already in the array (in which case we have hit a loop and we return the array)
    array = []

    while !array.include?(entry)
      array << entry
      entry = getNext(entry)
    end

    array
  end

  def pointingEntriesCount(entry)
    # returns the number of entries that are "upriver" of the current entry (of those currently stored in @allPages)

    @allPages.count do |_, candidateEntry|
      pointsTo(candidateEntry, entry)
    end
  end

  def pointingPages(page)
    @allPages.select do |_, candidatePage|
      pointsTo(candidatePage, page)
    end
  end

  def pointsTo(page, otherPage)
    # returns boolean of whether or not the chain of links starting an entry ever points to otherEntry


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

entry =  archivist.allPages["/wiki/Tahla_Mosque"]
entry =  archivist.allPages["/wiki/Stationary_steam_engine"]


puts entry

puts archivist.pointingEntriesCount(entry)
