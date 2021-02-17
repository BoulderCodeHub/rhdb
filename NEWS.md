# rhdb 0.2.0

* When successful query returns no data, the query now returns a data frame with one row. The row has the sdi, mrid, but `NA` for value, and no time_step. (#6)
* In `hdb_query()`, ensure that `end_date` is the same or after `start_date`. (#5)
* Added `hdb_metadata()` to get meta data, which makes it possible to find SDIs knowing a site name and variable type. (#4)
* `hdb_query()` will now try url multiple times before aborting. The number of times it tries the url is based on the `rhdb.try_url_n` option, which defaults to 5. (#3)
* Added package level documentation.

# rhdb 0.1.0-*

* `sdi` and `value` are now returned as numbers. (#2)
* curl is now a listed dependency. (#1)

# rhdb 0.1.0

* Initial release, includes one user function: `hdb_query()`
