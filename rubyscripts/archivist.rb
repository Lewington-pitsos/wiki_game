require_relative './shared/fileHelper'

class Archivist

  attr_accessor :allEntries

  include FileHelper

  def initialize
    @allEntries = getAllEntries()
  end

  def getNext(entry)
    # returns the entry whose url is the same as the nextUrl of this entry (should only ever be one)
    @allEntries.detect do |otherEntry|
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

    array
  end

  def popularEntries

    # for every page, gets the page's title and number of pages that link to it (directly or indirectly) and puts them into a sorted array.

    allEntries = []

    @allEntries.each do |entry|
      allEntries << {
        title: entry[:title],
        followers: getAllPreviousEntries(entry).length()
      }
    end

    allEntries.sort_by do |entry|
      entry[:followers]
    end
  end

  def getPrevious(entry)
    # gets all entries form the list whose nextUrl properties match the url property of the current entry
    @allEntries.select do |otherEntry|
      otherEntry[:nextUrl] == entry[:url]
    end
  end

  def pointsTo(entry, otherEntry)
    # returns boolean of whether or not the chain of links starting an entry ever points to otherEntry

    passedEntries = []

    while !passedEntries.include?(entry)
      if entry == otherEntry
        return true
      else
        passedEntries << entry
        entry = getNext(entry)
      end
    end

    false
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

for i in 20.. 80 do
  entry = archivist.allEntries[i]

  puts archivist.getAllPreviousEntries(entry).length

  puts entry[:title] + ' ' + i.to_s
end

puts archivist.pointsTo(archivist.allEntries[73], archivist.allEntries[74])
