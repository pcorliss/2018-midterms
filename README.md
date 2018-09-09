## Update 538 Data

```
curl https://projects.fivethirtyeight.com/2018-midterm-election-forecast/house/home.json > 538Forecast-2018-09-09.json
cat 538Forecast-2018-09-09.json | ruby 538-json-parser.rb > 538-forematted.csv
```

Upload `538-forematted.csv` to [Google Sheet](https://docs.google.com/spreadsheets/d/12VeQDEjRfm_kxwnsfrfypOoLmJFBOl1IkPCM2l0vJ28/edit#gid=1911024485)

## Update FEC Data

Export and Download From [FEC Source](https://www.fec.gov/data/candidates/house/)

```
cp ~/Downloads/totals-2018-09-09T14_16_50.csv FEC-2018-09-09.csv
```

## Update Primary Winners

Export as CSV [Google Sheet](https://docs.google.com/spreadsheets/d/12VeQDEjRfm_kxwnsfrfypOoLmJFBOl1IkPCM2l0vJ28/edit#gid=689373353)

```
cp ~/Downloads/2018\ House\ \$\ Efficiency\ -\ Primary\ Winners.csv ./PrimaryWinners.csv
```

## Update FEC Name Mapping

```
cat FEC-2018-09-09.csv | ruby reconcile_names.rb  > reconciled.csv
```

Upload `reconciled.csv` to [Google Sheet](https://docs.google.com/spreadsheets/d/12VeQDEjRfm_kxwnsfrfypOoLmJFBOl1IkPCM2l0vJ28/edit#gid=1569675494)
