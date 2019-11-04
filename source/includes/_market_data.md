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
    Prices can fluctuate very quickly and these prices are based on the data available at that moment. More price data is available through SFOX's <a href="#websocket">Websocket API</a>, if you want to trade now we recommend using a market <a href="buy-market-order">buy</a> or <a href="#sell-market-order">sell</a> order.
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

