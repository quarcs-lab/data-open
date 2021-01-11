# Description of datasets
The original data is from
http://ghdx.healthdata.org/ihme-data/global-human-capital-estimates-1990-2016

- `ehc`: Contains data for 195 countries for two years: 1990 and 2016.

| var_name   | var_def                                 | type    |
|------------|-----------------------------------------|---------|
| id         | Country id                              | numeric |
| country    | Country name                            | cs_id   |
| year       | year                                    | ts_id   |
| ehc        | Expected human capital                  | numeric |
| sur        | Expected years lived (0-45 years)       | numeric |
| fh         | Functional health status (0-100)        | numeric |
| edu        | Educational attainment (0-18 years)     | numeric |
| lea        | Learning (0-100)                        | numeric |
| region     | Regional classification based on UNCTAD | factor  |
| isoUNstats | ISO 3166 numeric code                   | factor  |
| isoPWT     | ISO code from Penn World Table 7.0      | factor  |
