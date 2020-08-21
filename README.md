
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

For example, Lake Powell’s daily historical elevation and release for
January 1-10, 2020 can be queried as follows:

``` r
library(rhdb)

df <- hdb_query(c(1872, 1928), "uc", "daily", "2020-01-01", "2020-01-10")
#> query url:
#> https://www.usbr.gov/pn-bin/hdb/hdb.pl?sdi=1872%2C1928&svr=uchdb2&tstp=DY&t1=2020-01-01T00:00&t2=2020-01-10T00:00&table=R&mrid=0&format=json
df
#>     sdi             time_step mrid          value units
#> 1  1872  1/1/2020 12:00:00 AM   NA   10605.146250   cfs
#> 2  1872  1/2/2020 12:00:00 AM   NA 12652.13791670   cfs
#> 3  1872  1/3/2020 12:00:00 AM   NA 12519.96958330   cfs
#> 4  1872  1/4/2020 12:00:00 AM   NA 12382.60541670   cfs
#> 5  1872  1/5/2020 12:00:00 AM   NA 10377.56666670   cfs
#> 6  1872  1/6/2020 12:00:00 AM   NA 12366.66666670   cfs
#> 7  1872  1/7/2020 12:00:00 AM   NA   12511.213750   cfs
#> 8  1872  1/8/2020 12:00:00 AM   NA   12726.081250   cfs
#> 9  1872  1/9/2020 12:00:00 AM   NA 12747.79416670   cfs
#> 10 1872 1/10/2020 12:00:00 AM   NA 12562.46708330   cfs
#> 11 1928  1/1/2020 12:00:00 AM   NA        3608.67  feet
#> 12 1928  1/2/2020 12:00:00 AM   NA        3608.60  feet
#> 13 1928  1/3/2020 12:00:00 AM   NA        3608.50  feet
#> 14 1928  1/4/2020 12:00:00 AM   NA        3608.39  feet
#> 15 1928  1/5/2020 12:00:00 AM   NA        3608.30  feet
#> 16 1928  1/6/2020 12:00:00 AM   NA        3608.17  feet
#> 17 1928  1/7/2020 12:00:00 AM   NA        3608.05  feet
#> 18 1928  1/8/2020 12:00:00 AM   NA        3607.89  feet
#> 19 1928  1/9/2020 12:00:00 AM   NA        3607.79  feet
#> 20 1928 1/10/2020 12:00:00 AM   NA        3607.63  feet
```

Additionally, Lake Mead’s projected elevations from the December 2018
24-Month Study model can be queried:

``` r
df <- hdb_query(1930, "lc", "monthly", "2018-12", "2019-12", mrid = 3081)
#> query url:
#> https://www.usbr.gov/pn-bin/hdb/hdb.pl?sdi=1930&svr=lchdb2&tstp=MN&t1=2018-12-01T00:00&t2=2019-12-01T00:00&table=M&mrid=3081&format=json
df
#>     sdi             time_step mrid             value units
#> 1  1930 12/1/2018 12:00:00 AM 3081   1081.3953471267  feet
#> 2  1930  1/1/2019 12:00:00 AM 3081 1085.229064866550  feet
#> 3  1930  2/1/2019 12:00:00 AM 3081   1086.1651309203  feet
#> 4  1930  3/1/2019 12:00:00 AM 3081 1083.493562660810  feet
#> 5  1930  4/1/2019 12:00:00 AM 3081 1078.513153553270  feet
#> 6  1930  5/1/2019 12:00:00 AM 3081 1073.818032368550  feet
#> 7  1930  6/1/2019 12:00:00 AM 3081 1070.402401179750  feet
#> 8  1930  7/1/2019 12:00:00 AM 3081 1069.672881959310  feet
#> 9  1930  8/1/2019 12:00:00 AM 3081 1070.809208532270  feet
#> 10 1930  9/1/2019 12:00:00 AM 3081   1070.0880025117  feet
#> 11 1930 10/1/2019 12:00:00 AM 3081   1069.5207717774  feet
#> 12 1930 11/1/2019 12:00:00 AM 3081 1068.049878643150  feet
#> 13 1930 12/1/2019 12:00:00 AM 3081 1068.069569860370  feet
```

## Log

  - 2020-08-21: version 0.1.0
