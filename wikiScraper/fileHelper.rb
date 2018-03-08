module FileHelper
  FILENAME = 'test.yaml'

  def saveTitleArray(array)
    # loads the contents of the record file, pushes the new array to the resulting value (should be an array of arrays)
    # overwrites the record file with the modified array
    allTitles = getAllTitles
    allTitles << array
    writeToFile(allTitles)
  end

  def getAllTitles
    YAML.load(File.read(FILENAME))
  end

  def writeToFile(value)
    # overwrites the record file with the value passed in
    file = File.open(FILENAME, 'w')
    file.write(value.to_yaml)
    file.close
  end
end
