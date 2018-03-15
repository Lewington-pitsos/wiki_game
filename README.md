# Automated Wikipedia Game

There's a theory that if you visit any random Wikipedia page and click the first link within the main text-body of the page, and keep doing that on all the successive pages you visit, you'll eventually end up on the "/wiki/Philosophy" page. This Automated Wikipedia Game is a basic Ruby language web scraper built to (kind of) test that theory.

## Use

Clone the repo and

```
$ bundle install
```

In the right directory. Then simply run

```
$ bundle exec scrape.rb

```

And scraping should begin post haste.

### Notes

`/Scrape.rb` along with `/rubyscripts/metaScraper.rb` act as a kind of veru janky config file.

As per `/Scrape.rb` I have been using a firefox broswer in headless mode. If you're a chrome guy/gal feel free to change that.

Data is stored in the `/database` folder. By default everything is saved to `database/test.yaml`. But this can be changed through `/rubyscripts/shared/fileHelper.rb`.

`/rubyscripts/archivist.rb` is very, very slow. If you have any idea how I could run analysis on this kind of data faster (without being some sort of SQL genius) please let me know.

## Approach

The biggest issue is operationalizing "first link within the main text-body". Intuitively this wouldn't include links within the .infobox, or so called .hatnotes, as well as links to audio files, footnotes, pronunciation notes, and so on. Unfortunately, because of Wikipedia's HTML layout however, there doesn't seem to be any easy way of doing this other than explicitly excluding every one of these classes of links individually. The result of which is this borderline-terrifying Xpath selector:

```
"//*[@class='mw-parser-output']//a[not(ancestor::table|ancestor::*[contains(@class, 'hatnote')]|ancestor::*[contains(@class, 'thumb')]|ancestor::*[contains(@class, 'IPA')]|ancestor::*[contains(@class, 'haudio')]|ancestor::*[@id='coordinates'])][not(starts-with(text(), '['))][not(contains(@class, 'image'))][starts-with(@href, '/wiki')]"
```

Granted, so far this selector seems to be working quite well, but I've still found it prudent to assume that errors *will* occur and more or less perpetually catch them with some logging so that whole scrapes aren't shot down by strange new links. I seem to get a strange error once in about 150 successfully scraped loops.

Assuming that all works the rest is simple:

  1. keep clicking on

## Results

#### Is /wiki/Philosopy the "Root Page"?

After scraping around 1500 pages, the "/wiki/philosophy" page turned out to be the descendant (all pages accessible through the link chain from a given page are considered it's "descendants") of a mere ____, so if nothing else we can put paid to our hypothesis.

#### Notes

The average number of descendants for each page (for ___ pages scraped ) turned out to be ___ , with the median being ___ . However, some pages had significantly more descendants.

For instance, "/wiki/Greek_Language" generaly tended to be a descendant of around 30% of all pages scraped.

Slightly more intersting, the title of page with the *most* descendants was actually a tie between "/wiki/Reality" and "/wiki/Existance", which feed directly into each other. Both remained descendants of roughly a whopping ___ % of all pages scraped throughout this project.

However, it's worth noting that most (around %) of the descendants for both these pages come to them through "/wiki/Language", which is a recent ancestor of theirs. This page could be considered a candidate for *"closest thing we have to a root page"* since if we discount it's descendants, it is the page with by far the most descendants, and without it it's descendants would not even have a particularly significant number of descendants.

## Technologies

See the Gemfile, but the most important tools are

  1. Watir (for visiting pages)
  2. Nokogiri (for finding page data and links)
