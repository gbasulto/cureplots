# Washington Road Crashes

Crashes on Washington primary roads from 2016, 2017, and 2018. Data
acquired from Washington Department of Transportation through the
Highway Safety Information System (HSIS).

## Usage

``` r
washington_roads
```

## Format

The data frame `washington_roads` has 1,501 rows and 9 columns:

- ID:

  Anonymized road ID. Factor.

- Year:

  Year. Integer.

- AADT:

  Annual Average Daily Traffic (AADT). Double.

- Length:

  Segment length in miles. Double.

- Total_crashes:

  Total crashes. Integer.

- lnaadt:

  Natural logarithm of AADT. Double.

- lnlength:

  Natural logarithm of length in miles. Double.

- speed50:

  Indicator of whether the speed limit is 50 mph or greater. Binary.

- ShouldWidth04:

  Indicator of whether the shoulder is 4 feet or wider. Binary.

## Source

\<https://highways.dot.gov/research/safety/hsis\>
