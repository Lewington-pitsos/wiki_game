FLS = "//*[@class='mw-parser-output']//a[not(ancestor::table|ancestor::*[contains(@class, 'hatnote')]|ancestor::*[contains(@class, 'thumb')]|ancestor::*[contains(@class, 'IPA')]|ancestor::*[contains(@class, 'haudio')]|ancestor::*[@id='coordinates'])][not(starts-with(text(), '['))][not(contains(@class, 'image'))][starts-with(@href, '/wiki')]"


fls =  "//*[@class='mw-parser-output']//a" +
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


puts fls == FLS
