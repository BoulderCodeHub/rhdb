# rhdb 0.2.1-n

*In development*

* Added in LC reservoir metadata.

# rhdb 0.2.1

* For empty data, the columns were being returned as lists, instead of characters and numerics. This was fixed so the empty data frame only includes characters and numerics. (#8)

# rhdb 0.2.0

*Released February 17, 2021*

## Bug Fixes

* When successful query returns no data, the query now returns a data frame with one row. The row has the sdi, mrid, but `NA` for value, and no time_step. (#6)
* In `hdb_query()`, now ensure that `end_date` is the same or after `start_date`. (#5)

## Minor Enhancemnts

* Added `hdb_metadata()` to get meta data, which makes it possible to find SDIs knowing a site name and variable type. (#4)
* `hdb_query()` will now try url multiple times before aborting. The number of times it tries the url is based on the `rhdb.try_url_n` option, which defaults to 5. (#3)
* Added package level documentation.

# rhdb 0.1.0-*

* `sdi` and `value` are now returned as numbers. (#2)
* curl is now a listed dependency. (#1)

# rhdb 0.1.0

* Initial release, includes one user function: `hdb_query()`
