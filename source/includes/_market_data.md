# Market Data

## Smart Routing Order Estimate

```shell
$ curl "https://api.sfox.com/v1/offer/buy?amount=1"
```

```python
requests.get("https://api.sfox.com/v1/offer/buy", params={"amount": 1}).json()
```

> The result of the calls is something like this:

```json
{
  "quantity":1,
  "vwap":383.00,
  "price":383.21,
  "fees":0.95,
  "total":382.26
}
```

Get an estimated execution price for the specified quantity of a given asset using SFOX's Smart Order Routing, as well as related information. **Only use this as an estimate - execution is not guaranteed.**


<aside class="notice">
    Prices can fluctuate very quickly.  More current price data is available through SFOX's <a href="#websocket-feeds">Websocket API</a>.
</aside>

### HTTP Request

Buy:

`GET /v1/offer/buy?amount=1`

Sell:

`GET /v1/offer/sell?amount=1`

### Query Parameters

Parameter | Required | Default | Description
--------- | :-------: | ----------- | ----------
amount| Y | | The amount you will be trading (base currency).
pair | N | btcusd | The pair you will be trading.

### Response Body

Key | Description
--- | -----------
quantity | Quantity to buy or sell
vwap | "Volume Weighted Average Price", the price the user can expect to receive if the order is executed. Even though the price is $383.21 in this example, you will most likely pay $383 for the entire order. These prices are not guaranteed as the market is always moving.
price | Limit price the user must specify when placing the order to achieve the VWAP price at execution
fees | Expected fee for executing this order
total | Total cost of the order

<aside class="notice">
    VWAP, Price, Fees, and Total are in the quote currency (e.g. USD for a btcusd pair).
</aside>

## OHLCV

Access historical aggregated OHLCV data from all supported liquidity providers.

```shell
curl "https://chartdata.sfox.com/candlesticks?endTime=1592951280&pair=btcusd&period=60&startTime=1592939280"
```

```python
requests.get("https://chartdata.sfox.com/candlesticks?endTime=1592951280&pair=btcusd&period=60&startTime=1592939280").json()
```

> The result is an array of OHLCV datapoints:

```json
[
  {
    "open_price":"9654",
    "high_price":"9662.37",
    "low_price":"9653.66",
    "close_price":"9655.73",
    "volume":"6.31945755",
    "start_time":1592939280,
    "pair":"btcusd",
    "candle_period":60,
    "vwap":"9655.70504211",
    "trades":53
  },
  {
    "open_price":"9655.72",
    "high_price":"9663.381",
    "low_price":"9653.8",
    "close_price":"9653.9",
    "volume":"19.78230049",
    "start_time":1592939340,
    "pair":"btcusd",
    "candle_period":60,
    "vwap":"9654.19237263",
    "trades":56
    },
  ...
]
```

### HTTP Request

`GET https://chartdata.sfox.com/candlesticks?startTime=<startTime>&pair=<pair>&period=<period>&endTime=<endTime>` 

### Query Parameters
Parameter | Required | Default | Description
--------- | -------- | ------- | -----------
pair | N | btcusd | The pair you want data for 
startTime | N | | The unix timestamp of the first datapoint returned 
endTime | N | | The unix timestamp of the last datapoint you want returned
period | N | | The duration of each datapoint or candle in seconds (i.e. period = 60 would return 1-minute candles)


### Response Body
Key | Description
--- | -----------
open_price | The price at the start of that period
high_price | The highest price reached during that period
low_price | The lowest price reached during that period
close_price | The price at the end of that period
volume | Total volume of the asset traded during that period
start_time | The unix timestamp of the beginning of the period
end_time | The unix timestamp of the end of the period
pair | The trading pair of the data
candle _period | The duration of each datapoint in seconds
vwap | The volume-weighted average price of the period
trades | The total number of trades executed across all liquidity providers during that period


## Orderbook

Get the blended L2 orderbook data of our connected exchanges, including the top bids and asks and the location of those bids and asks.

```shell
curl "https://api.sfox.com/v1/markets/orderbook/<asset_pair>"
```

```python
requests.get("https://api.sfox.com/v1/markets/orderbook/<asset_pair>").json()
```

> The result of the calls is an array of bids and asks:

```json
{
  "bids": [
    [
      9458.12,
      1e-08,
      "gemini"
    ],
    [
      9456,
      1,
      "itbit"
    ],
    [
      9453,
      0.73553115,
      "itbit"
    ],
    // truncated
  "asks": [
    [
      9455.55,
      2.03782954,
      "market1"
    ],
    [
      9455.56,
      0.9908,
      "market1"
    ],
    [
      9455.59,
      0.60321264,
      "market1"
    ],
    // truncated
  "market_making": {
    "bids": [
      [
        9447.34,
        2,
        "bitstamp"
      ],
      [
        9452.01,
        0.60321264,
        "market1"
      ],
      [
        9452.31,
        0.47488688,
        "bittrex"
      ],
      [
        9456,
        1,
        "itbit"
      ],
      [
        9458.12,
        1e-08,
        "gemini"
      ]
    ],
    "asks": [
      [
        9458.13,
        2.07196048,
        "gemini"
      ],
      [
        9457.75,
        0.14748797,
        "itbit"
      ],
      [
        9456,
        0.1686167,
        "bittrex"
      ],
      [
        9455.68,
        0.742406,
        "bitstamp"
      ],
      [
        9455.55,
        2.03782954,
        "market1"
      ]
    ]
  },
  "timestamps": {
    "gemini": [
      1572903458537,
      1572903458538
    ],
    "bitstamp": [
      1572903458199,
      1572903458199
    ],
    "itbit": [
      1572903458414,
      1572903458416
    ],
    "bittrex": [
      1572903458517,
      1572903458517
    ],
    "market1": [
      1572903458071,
      1572903458071
    ]
  },
  "lastupdated": 1572903458756,
  "pair": "btcusd",
  "currency": "usd",
  "lastpublished": 1572903458798
}
```

### HTTP Request

The default pair is `btcusd`

`GET /v1/markets/orderbook`

However if you want to specify a pair:

`GET /v1/markets/orderbook/ethusd`

### Response Body

Key | Description
--- | -----------
pair | The trading pair
currency | The quote currency
asks | List of asks, size, and exchange
bids | List of the bids, size, and exchange
market\_making | List of the best bid and ask on each exchange
timestamps | A list of exchanges and the latest timestamps of the orderbook
lastupdated | Last update of the blended orderbook
lastpublished | Last time an orderbook update was published

