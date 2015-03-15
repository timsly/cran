# CRAN

CRAN server indexer.

http://cran.herokuapp.com/ (Indexed ~5k packages, because heroku free db limited for 10K rows)

## Indexation

To index avaialble packages you need to run

    $ bundle exec rake packages:index

Currently CRAN contains 6411 available packages. So not to index all packages just press CTRL+C during indexation.

## Handling authors and maintainers

Initially I planned to store authors and maintainers in the people table and link
to the package version via mapping table(using has_many through technique).
I even start working on that(see [people](https://github.com/timsly/cran/tree/people) branch).
But after I discovered few packages i realized that there are no advantages in this approach, because:

* email is not always present, so we don't have source that we can use as unique indentifier during merging.
  Rely on the name, to my mind, is not very accurate, because we can have hundreds of John Smiths,
  but we cannot assume that all of them are the same person.
  So that's why we cannot do data normalization and, for example, cannot create page for author or maintainer,
  because data on that page won't be accurate
* external table add some not necessary complexity and increase implementation time

So that's why authors and maintainers serialized into fields in the versions table.

## Possible  indexation algorythm

Currently, to check the latest version of the package i use PACKAGES file and try to find which package release new version.
The biggest problem that there is no file  where i can see the latest updated packages.

Theoretically, we can parse output for request like - http://cran.r-project.org/src/contrib/?C=M;O=D.
This request returns apache html code after clicking on sort by last modified link.
After we parse this request we can have list with recently udpated packages first.
Then we can store date of the last indexation and get only packages that was updated after that date.

## Issues with treetop-dcf gem

treetop-dcf parser was extremly slow on PACKAGES file parsing, so that's why i use regular expression instead.

## TODO

* [ ] Index archive packages from http://cran.r-project.org/src/contrib/Archive/
