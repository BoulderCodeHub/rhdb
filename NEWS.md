# rhdb 0.2.0

* When successful query returns no data, the query now returns a data frame with one row. The row has the sdi, mrid, but `NA` for value, and no time_step. (#6)

# rhdb 0.1.0-*

* `sdi` and `value` are now returned as numbers. (#2)
* curl is now a listed dependency. (#1)

# rhdb 0.1.0

* Initial release, includes one user function: `hdb_query()`
