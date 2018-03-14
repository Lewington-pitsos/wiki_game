require 'yaml'

module FileHelper
  FILENAME = './database/db.yaml'
  # path always from root dir (of project or terminal I guess)

  def saveEntry(entry)
    # loads the contents of the record file, pushes the new array to the resulting value (should be an array of arrays)
    # overwrites the record file with the modified array
    allEntries = getAllEntries
    allEntries << entry
    writeToFile(allEntries)
  end

  def getAllEntries
    YAML.load(File.read(FILENAME))
  end

  def writeToFile(value)
    # overwrites the record file with the value passed in
    file = File.open(FILENAME, 'w')
    file.write(value.to_yaml)
    file.close
  end
end
