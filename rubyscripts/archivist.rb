require_relative './shared/fileHelper'

class Archivist

  attr_accessor :allPages

  include FileHelper

  def initialize
    @allPages = getAllEntries()
  end

  def getNext(entry)
    # returns the entry whose url is the same as the nextUrl of this entry (should only ever be one)
    @allPages.detect do |otherEntry|
      otherEntry[:url] == entry[:nextUrl]
    end
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

    p array
  end

  def getPrevious(entry)
    # gets all entries form the list whose nextUrl properties match the url property of the current entry
    @allPages.select do |otherEntry|
      otherEntry[:nextUrl] == entry[:url]
    end
  end

  def getAllPreviousEntries(entry, allEntries=[])
    # is passed in a page entry and an array representing all the page entries found so far
    # if the current entry isn't already in the allEntries we add entry to the array, gather all those elements directly previous (linkiing) to the current entry, and call this same function on all of them with the same array passed in
    # each function call returns allEntries

    if !allEntries.include?(entry)
      allEntries << entry

      directlyPrevious = getPrevious(entry)

      directlyPrevious.each do |prevEntry|
        getAllPreviousEntries(prevEntry, allEntries)
      end
    end

    allEntries
  end
end


archivist = Archivist.new

entry =  archivist.allPages[8]

p entry

p archivist.getAllPreviousEntries(entry).map {|e| e[:title] }
