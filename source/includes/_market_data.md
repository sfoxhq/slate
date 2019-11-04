# Market Data

## Smart Routing Order Data

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

This will return the current available price to buy or sell a user-specified quantity of an asset.

To get the sell price simply change `buy` to `sell` in the url.

<aside class="notice">
    Prices can fluctuate very quickly and these prices are based on the data available at that moment. More price data is available through SFOX's <a href="#websocket">Websocket API</a>, if you want to trade now we recommend using a market <a href="#place-a-buy-order">buy</a> or <a href="#place-a-sell-order">sell</a> order.
</aside>

### HTTP Request

Buy:

`GET /v1/offer/buy?amount=1`

Sell:

`GET /v1/offer/sell?amount=1`

### Query Parameters

Parameter | Required | Default | Description
--------- | :-------: | ----------- | ----------
amount| Y | | The amount of crypto assets you will be trading
pair | N | btcusd | The pair you will be trading

### Response Body

Key | Description
--- | -----------
quantity | Quantity to buy or sell
vwap | "Volume Weighted Average Price", the price the user can expect to receive if the order is executed. Even though the price is $383.21 in this example, you will most likely pay $383 for the entire order. These prices are not guaranteed as the market is always moving.
price | Limit price the user must specify to achieve the VWAP price at execution
fees | Expected fee for executing this order
total | Total cost of the order

## Get Orderbook

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
market\_making |
timestamps | A list of exchanges and the latest timestamps of the orderbook
lastupdated | Last update of the blended orderbook
lastpublished | Last time an orderbook update was published

