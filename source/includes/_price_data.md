# Price Data

## Get Best Price

```shell
curl "https://api.sfox.com/v1/offer/buy?amount=1"
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

This will return the price you need to specify for a limir order to execute fully. Please note that price fluctuates very quickly and this price is based on the data available at that moment.  If you want to trade now, we recommend using Buy Now and Sell Now calls and not limit orders.

To get the sell price simply change "buy" to "sell" in the url.

Use the "price" returned to you as the price in limit order you're placing.

We also return VWAP - Volume weighted average price.  "vwap" is the expected price you will pay for the entire order.  Even though the price is 383.21 in this example, you will most likely pay $383 for the entire order.  These prices are not guaranteed as the market is always moving.  

### HTTP Request

`GET /v1/offer/buy?quantity`

### Query Parameters

Parameter | Default | Description
--------- | ------- | -----------
quantity||The amount of crypto assets you will be trading


## Get Orderbook

```shell
curl "https://api.sfox.com/v1/markets/orderbook/<asset_pair>"
```

> The result of the calls is an array of bids and asks:

```json
{
  "asks": [
    [8155.1, 0.3881078, "gemini"],
    [8155.4, 0.42019816, "gemini"],
    [8155.41, 0.64771848, "gemini"],
    [8157.04, 3.9171, "itbit"],
    [8157.97, 1.3509, "itbit"],
    [8159.24, 2.04259106, "bitstamp"]
  ],
  "bids": [
    [8169.99, 0.00196, "gemini"],
    [8169, 0.0921289, "bitfinex"],
    [8168.61, 0.001, "bitstamp"],
    [8168.51, 1.50982744, "itbit"],
    [8168.47, 0.001, "bitfinex"],
    [8168.26, 0.001, "bitfinex"]
  ],
  "currency": "usd",
  "exchanges": {
    "bitfinex": "OK",
    "bitstamp": "OK",
    "gemini": "OK",
    "itbit": "OK"
  },
  "lastupdated": 1532994078139,
  "pair": "btcusd"}
```

This will return the blended orderbook of all the available exchanges.

### HTTP Request

`GET /v1/markets/orderbook`

### Query Parameters

Parameter | Default | Description
--------- | ------- | -----------
NONE

