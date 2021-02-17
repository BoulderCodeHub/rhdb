
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rhdb

<!-- badges: start -->

<!-- badges: end -->

rhdb provides an R interface into the Burea of Reclamation’s public
facing hydrologic database (HDB). This package queries HDB throght the
API at
<https://www.usbr.gov/lc/region/g4000/riverops/_HdbWebQuery.html>.

## Installation

rhdb is currently only available on GitHub and can beinstalled as
follows:

``` r
# install.packages("remotes")
remotes::install_github("BoulderCodeHub/rhdb")
```

## Usage

rhdb can be used to query observed and modeled data from HDB. The data
are returned in a data frame. At this time, it is up to the user to know
the Site-Datetype ID (sdi) and the server that sdi is stored on. The
model run id (mrid) only needs to be specified when querying modeled
data.

rhdb includes one function to get data from hdb (`hdb_query()`) and one
function to get metadata associated with data types and names
(`hdb_metadata()`). `hdb_query()` can be used to match all queries that
are possible from the above link.

For example, Lake Powell’s daily historical elevation and release for
January 1-10, 2020 can be queried as follows:

``` r
library(rhdb)

df <- hdb_query(c(1872, 1928), "uc", "daily", "2020-01-01", "2020-01-10")
#> query url:
#> https://www.usbr.gov/pn-bin/hdb/hdb.pl?sdi=1872%2C1928&svr=uchdb2&tstp=DY&t1=2020-01-01T00:00&t2=2020-01-10T00:00&table=R&mrid=0&format=json
df
#>     sdi             time_step mrid    value units
#> 1  1872  1/1/2020 12:00:00 AM   NA 10605.15   cfs
#> 2  1872  1/2/2020 12:00:00 AM   NA 12652.14   cfs
#> 3  1872  1/3/2020 12:00:00 AM   NA 12519.97   cfs
#> 4  1872  1/4/2020 12:00:00 AM   NA 12382.61   cfs
#> 5  1872  1/5/2020 12:00:00 AM   NA 10377.57   cfs
#> 6  1872  1/6/2020 12:00:00 AM   NA 12366.67   cfs
#> 7  1872  1/7/2020 12:00:00 AM   NA 12511.21   cfs
#> 8  1872  1/8/2020 12:00:00 AM   NA 12726.08   cfs
#> 9  1872  1/9/2020 12:00:00 AM   NA 12747.79   cfs
#> 10 1872 1/10/2020 12:00:00 AM   NA 12562.47   cfs
#> 11 1928  1/1/2020 12:00:00 AM   NA  3608.67  feet
#> 12 1928  1/2/2020 12:00:00 AM   NA  3608.60  feet
#> 13 1928  1/3/2020 12:00:00 AM   NA  3608.50  feet
#> 14 1928  1/4/2020 12:00:00 AM   NA  3608.39  feet
#> 15 1928  1/5/2020 12:00:00 AM   NA  3608.30  feet
#> 16 1928  1/6/2020 12:00:00 AM   NA  3608.17  feet
#> 17 1928  1/7/2020 12:00:00 AM   NA  3608.05  feet
#> 18 1928  1/8/2020 12:00:00 AM   NA  3607.89  feet
#> 19 1928  1/9/2020 12:00:00 AM   NA  3607.79  feet
#> 20 1928 1/10/2020 12:00:00 AM   NA  3607.63  feet
```

Additionally, Lake Mead’s projected elevations from the December 2018
24-Month Study model can be queried:

``` r
df <- hdb_query(1930, "lc", "monthly", "2018-12", "2019-12", mrid = 3081)
#> query url:
#> https://www.usbr.gov/pn-bin/hdb/hdb.pl?sdi=1930&svr=lchdb2&tstp=MN&t1=2018-12-01T00:00&t2=2019-12-01T00:00&table=M&mrid=3081&format=json
df
#>     sdi             time_step mrid    value units
#> 1  1930 12/1/2018 12:00:00 AM 3081 1081.395  feet
#> 2  1930  1/1/2019 12:00:00 AM 3081 1085.229  feet
#> 3  1930  2/1/2019 12:00:00 AM 3081 1086.165  feet
#> 4  1930  3/1/2019 12:00:00 AM 3081 1083.494  feet
#> 5  1930  4/1/2019 12:00:00 AM 3081 1078.513  feet
#> 6  1930  5/1/2019 12:00:00 AM 3081 1073.818  feet
#> 7  1930  6/1/2019 12:00:00 AM 3081 1070.402  feet
#> 8  1930  7/1/2019 12:00:00 AM 3081 1069.673  feet
#> 9  1930  8/1/2019 12:00:00 AM 3081 1070.809  feet
#> 10 1930  9/1/2019 12:00:00 AM 3081 1070.088  feet
#> 11 1930 10/1/2019 12:00:00 AM 3081 1069.521  feet
#> 12 1930 11/1/2019 12:00:00 AM 3081 1068.050  feet
#> 13 1930 12/1/2019 12:00:00 AM 3081 1068.070  feet
```

A user could find the correct sdi for Powell’s inflow by searching the
metadata:

``` r
library(dplyr)
library(stringr)

md <- hdb_metadata()
md %>%
  filter(str_detect(site_metadata.site_name, "POWELL")) %>%
  select(site_datatype_id, site_metadata.site_name, 
         datatype_metadata.datatype_common_name)
#>    site_datatype_id site_metadata.site_name
#> 1              1712             LAKE POWELL
#> 2              1719             LAKE POWELL
#> 3              1774             LAKE POWELL
#> 4              1792             LAKE POWELL
#> 5              1840             LAKE POWELL
#> 6              1851             LAKE POWELL
#> 7              1856             LAKE POWELL
#> 8              1862             LAKE POWELL
#> 9              1872             LAKE POWELL
#> 10             1920             LAKE POWELL
#> 11             1928             LAKE POWELL
#> 12             2216             LAKE POWELL
#> 13             4166             LAKE POWELL
#> 14             4167             LAKE POWELL
#> 15             4168             LAKE POWELL
#> 16            14202             LAKE POWELL
#> 17            14203             LAKE POWELL
#>    datatype_metadata.datatype_common_name
#> 1                            bank storage
#> 2                                 storage
#> 3                             evaporation
#> 4                                  inflow
#> 5                           inflow volume
#> 6                      unregulated inflow
#> 7               unregulated inflow volume
#> 8                           power release
#> 9                           total release
#> 10                         release volume
#> 11                         pool elevation
#> 12                   power release volume
#> 13                       spillway release
#> 14                         bypass release
#> 15                  bypass release volume
#> 16                          delta storage
#> 17                                   area
```

Based on the above, the SDI 1792 is Powell’s inflow.

## Log

  - 2021-02-17: version 0.2.0
  - 2020-08-21: version 0.1.0
