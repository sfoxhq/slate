---
title: API Reference

language_tabs:
  - shell
  - python

toc_footers:
  - <a href='https://trade.sfox.com/account/api'>Sign Up for a Developer Key</a>
  - <a href='mailto:support@sfox.com'>Need help? Email us</a>

includes:
  - errors

search: true
---

# Introduction

Welcome to the SFOX API! The API allows you to connect your application to SFOX, execute trades, and deposit and withdraw crypto assets.

# Endpoints

Endpoint | Description
--------- | -----------
Production | https://api.sfox.com
Sandbox | [Contact support](mailto:support@sfox.com)

# Authentication

> To authorize, use this code:

```shell
# With shell, you can just pass the correct header with each request
curl "api_endpoint_here" \
  -u "<api token>:"
```

```python
import requests
auth = requests.auth.HTTPBasicAuth("<api_token>", "")
requests.get("api_endpoint_here", auth=auth)
```

> Make sure to replace <api_key> with your API key, and don't forget the colon.

SFOX uses API keys to grant access. You can create a new SFOX API key at our [developer portal](https://trade.sfox.com/account/api).

The API key should be included in all API requests to the server in a header that looks like the following:

`Authorization: Bearer <api_key>`

<aside class="notice">
You must replace `api_key` with your personal API key.
</aside>

# Price Data

## Get Best Price

```shell
curl "https://api.sfox.com/v1/offer/buy?amount=1"
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

This will return the blended orderbook of all the available exchanges.

### HTTP Request

`GET /v1/markets/orderbook`

# User

## Get Account Balance

```shell
curl "https://api.sfox.com/v1/user/balance" \
  -u "<api_key>:"
```

```python
requests.get("https://api.sfox.com/v1/user/balance", auth=requests.auth.HTTPBasicAuth("<api_key>", "")).json()
```

> The above command returns JSON structured like this:

```json
[
  {
    "currency":"btc",
    "balance":0.627,
    "available":0
  },
  {
    "currency":"usd",
    "balance":0.25161318,
    "available":0.23161321
  }
]
```

Use this endpoint to access your account balance.  It returns an array of objects, each of which has details for a single asset.

You will get Balance and Available balance.  Balance is your total balance for this asset.  Available, on the other hand, is what is available to you to trade and/or withdraw.  The difference is amount that is reserved either in an open trade or pending a withdrawal request.

### HTTP Request

`GET /v1/balance`

## Get Trade History

```shell
curl "https://api.sfox.com/v1/account/transactions?from=0=250&to=1565114130000" \
  -u "<api_key>:"
```

```python
requests.get(
    "https://api.sfox.com/v1/account/transactions",
    auth=requests.auth.HTTPBasicAuth("<api_key>", ""),
    params={"from": 0, "to": 1565114130000}
).json()
```

> The above command returns JSON structured like this:

```
[
  {
    'id': 12224191,
    'order_id': '67662454',
    'client_order_id': '',
    'day': '2018-07-29T21:30:10.000Z',
    'action': 'Buy',
    'currency': 'usd',
    'memo': '',
    'amount': -438.34854806,
    'net_proceeds': -438.34854806,
    'price': 465.19547184,
    'fees': 1.53,
    'status': 'done',
    'hold_expires': '',
    'tx_hash': '',
    'algo_name': 'Smart',
    'algo_id': '200',
    'account_balance': 3929.90349381,
    'AccountTransferFee': None
  }
]
```

Use this endpoint to access your trade history.  It returns an array of objects, each of which has details for each individual trade.


### HTTP Request

`GET /v1/account/transactions`

### Query Parameters

Parameter | Default | Description
--------- | ------- | -----------
to | 0 | Starting timestamp (in millis)
from | utcnow | Ending timestamp (in millis)


## Request an ACH deposit

```shell
curl "https://api.sfox.com/v1/user/bank/deposit" \
  -H "Authorization: <api_key>" \
  -d "amount=1"
```

```python
requests.post(
    "https://api.sfox.com/v1/user/bank/deposit",
    auth=requests.auth.HTTPBasicAuth("<api_key>", ""),
    json={"amount": 1}
).json()
```

> The above command returns JSON structured like this:

```json
{
  "tx_status": 0000,
  "success": true
}
```

You can transfer funds from your bank account to SFOX using ACH.  You have to setup your bank account by going to [Accounts / Deposits](https://trade.sfox.com/account).  Once you have setup your bank account, you can use this call to initiate the transfer request.

<aside class="notice">If the request fails, the json result will include an error field with the reason.</aside>

### HTTP Request

`POST /v1/user/bank/deposit`

### Form/JSON Parameters

Parameter | Description
--------- | -----------
amount | The amount you wish to deposit from your bank account

## Deposit Funds

```shell
curl "https://api.sfox.com/v1/user/deposit/address/{currency}" \
  -H "Authorization: <api_key>"
```

```python
requests.post(
    "https://api.sfox.com/v1/user/deposit/address/{currency}",
    auth=requests.auth.HTTPBasicAuth("<api_key>", ""),
).json()
```

> The above command returns JSON structured like this:

```json
{
  "address": "<address>",
  "currency": "<currency>"
}
```

Submit a request to create an additional or new crypto deposit address. Once submitted, the old and new addresses will allow for a deposit of currency choice.  For fiat deposit, your bank account must be setup prior to making the deposit request.

### Form Parameters

Parameter | Description
--------- | -----------
currency | Currency of choice: btc, bch, eth, ltc


## Withdraw Funds

```shell
curl "https://api.sfox.com/v1/user/withdraw" \
  -H "Authorization: <api_key>" \
  -d "amount=1" \
  -d "address=" \
  -d "currency=usd"
```

```python
requests.post(
    "https://api.sfox.com/v1/user/withdraw",
    auth=requests.auth.HTTPBasicAuth("<api_key>", ""),
    json={"amount": 1, "address": "<address if crypto>", "currency": "<currency>"}
).json()
```

> The above command returns JSON structured like this:

```json
{
  "success": true
}
```

Submits a asset withdrawal request to SFOX.  Your funds must be available before requesting withdrawal.  For fiat currency withdrawal, your bank account must be setup prior to making the withdrawal request.  You can setup your bank account by going to [Accounts / Deposits](https://api.sfox.com/#/account/deposit).

<aside class="notice">If the request fails, the json result will include an error field with the reason.</aside>

### HTTP Request

`POST /v1/user/withdraw`

### Form/JSON Parameters

Parameter | Description
--------- | -----------
amount | The amount you wish to withdraw
currency | Currency is one of: usd, btc, eth
address | if the "currency" is a crypto asset, this field has to be a valid mainnet address. Otherwise leave it out or empty


# Orders

## Buy (Market Order)

```shell
curl "https://api.sfox.com/v1/orders/buy" \
  -u "<api_key>:" \
  -d "quantity=1" \
  -d "currency_pair=btcusd"
```

```python
requests.post(
    "https://api.sfox.com/v1/orders/buy",
    auth=requests.auth.HTTPBasicAuth("<api_key>", ""),
    json={"quantity": 1, "currency_pair": "<currency_pair>"}
).json()
```

> The above command returns the same JSON object as the Order Status API, and it is structured like this:

```json
{
  "id": 666,
  "quantity": 1,
  "price": 10,
  "o_action": "Buy",
  "pair": "btcusd",
  "type": "Limit",
  "vwap": 0,
  "filled": 0,
  "status": "Started"
}
```

This is a market order request to buy certain quantity of a crypto assets.  Since this is a "Buy Now" order, it will execute immediately.

### HTTP Request

`POST /v1/orders/buy`

### Form/JSON Parameters

Parameter | Description
--------- | -----------
quantity | the amount of crypto assets you wish to buy
currency_pair | the currency pair


## Buy (Limit Order)

```shell
curl "https://api.sfox.com/v1/orders/buy" \
  -u "<api_key>:" \
  -d "quantity=1" \
  -d "price=10" \
  -d "currency_pair=btcusd"
```

```python
requests.post(
    "https://api.sfox.com/v1/orders/buy",
    auth=requests.auth.HTTPBasicAuth("<api_key>", ""),
    json={
        "quantity": 1,
        "price": 10,
        # optional:
        "currency_pair": "<currency_pair>",
        "algorithm_id": 200,
        "client_order_id": "<client provided reference>",
    }
).json()
```

> The above command returns the same JSON object as the Order Status API, and it is structured like this:

```json
{
  "id": 666,
  "quantity": 1,
  "price": 10,
  "o_action": "Buy",
  "pair": "btcusd",
  "type": "Limit",
  "vwap": 0,
  "filled": 0,
  "status": "Started"
}
```

This endpoint initiates a buy order for crypto assets at the specified amount with the specified limit price.  If the price field is omitted, then the order will be treated as a market order and will execute immediately.  If there is an issue with the request you will get the reason in the "error" field.

### HTTP Request

`POST /v1/orders/buy`

### Query Parameters

Parameter | Description
--------- | -----------
quantity | the amount of crypto assets you wish to buy
currency_pair | the asset pair you wish to trade (default: btcusd)
price | the max price you are willing to pay.  The executed price will always be less than or equal to this price if the market conditions allow it, otherwise the order will not execute.
algorithm_id | the [algorithm id](#algorithm-ids) you wish to use to execute the order (default: 200)
client_order_id | this is an optional field that will hold a user specified id for reference


## Sell (Market Order)

```shell
curl "https://api.sfox.com/v1/orders/sell" \
  -u "<api_key>:" \
  -d "quantity=1" \
  -d "currency_pair=btcusd"
```

```python
requests.post(
    "https://api.sfox.com/v1/orders/sell",
    auth=requests.auth.HTTPBasicAuth("<api_key>", ""),
    json={
        "quantity": 1,
        "currency_pair": "<currency_pair>",
    }
).json()
```

> The above command returns the same JSON object as the Order Status API, and it is structured like this:

```json
{
  "id": 667,
  "quantity": 1,
  "price": 10,
  "o_action": "Sell",
  "pair": "btcusd",
  "type": "Limit",
  "vwap": 0,
  "filled": 0,
  "status": "Started"
}
```
This is a market order request to sell certain quantity of crypto assets.  Since this is a "Sell Now" order, it will execute immediately.


### HTTP Request

`POST /v1/orders/sell`

### Form/JSON Parameters

Parameter | Description
--------- | -----------
quantity | the amount of crypto assets you wish to buy
currency_pair | the currency pair to trade

## Sell (Limit Order)

```shell
curl "https://api.sfox.com/v1/orders/sell" \
  -u "<api_key>:" \
  -d "quantity=1" \
  -d "price=10" \
  -d "currency_pair=btcusd"
```

```python
requests.post(
    "https://api.sfox.com/v1/orders/sell",
    auth=requests.auth.HTTPBasicAuth("<api_key>", ""),
    json={
        "quantity": 1,
        "price": 10,
        # optional
        "currency_pair": "<currency_pair>",
        "algorithm_id": 200,
        "client_order_id":
    }
).json()
```

> The above command returns the same JSON object as the Order Status API, and it is structured like this:

```json
{
  "id": 667,
  "quantity": 1,
  "price": 10,
  "o_action": "Sell",
  "pair": "btcusd",
  "type": "Limit",
  "vwap": 0,
  "filled": 0,
  "status": "Started"
}
```

This endpoint initiates a sell order for the specified amount with the specified limit price.  If the price field is omitted, then the order will be treated as a market order and will execute immediately.  If there is an issue with the request you will get the reason in the "error" field.

### HTTP Request

`POST /v1/orders/sell`

### Form/JSON Parameters

Parameter | Description
--------- | -----------
quantity | the amount of crypto assets you wish to buy
price | the min price you are willing to accept.  The executed price will always be higher than or equal to this price if the market conditions allow it, otherwise the order will not execute.
algorithm_id | the [algorithm id](#algorithm-ids) you wish to use to execute the order (default: 200)
client_order_id | this is an optional field that will hold a user specified id for reference
currency_pair | the asset pair you wish to trade (default: btcusd)


## Get Order Status

```shell
curl "https://api.sfox.com/v1/orders/<order_id>" \
  -u "<api_key>:"
```

```python
requests.post(
    "https://api.sfox.com/v1/orders/<order_id>",
    auth=requests.auth.HTTPBasicAuth("<api_key>", "")
).json()
```

> The above command returns a JSON structured like this:

```json
{
  "id": 666,
  "quantity": 1,
  "price": 10,
  "o_action": "Buy",
  "pair": "btcusd",
  "type": "Limit",
  "vwap": 0,
  "filled": 0,
  "status": "Started"
}
```

This endpoint returns the status of the order specified by the `<order_id>` url parameter

### HTTP Request

`GET /v1/orders/<order_id>`

### Possible "status" values

Value | Description
--------- | -----------
Started | The order is open on the marketplace waiting for fills
Cancel pending | The order is in the process of being cancelled
Canceled | The order was successfully canceled
Filled | The order was filled
Done | The order was completed successfully




## Get Active Orders

```shell
curl "https://api.sfox.com/v1/orders" \
  -u "<api_key>:"
```

```python
requests.get("https://api.sfox.com/v1/orders", auth=requests.auth.HTTPBasicAuth("<api_key>", "")).json()
```

> The above command returns an array of Order Status JSON objects structured like this:

```json
[
  {
    "id": 666,
    "quantity": 1,
    "price": 10,
    "o_action": "Buy",
    "pair": "btcusd",
    "type": "Limit",
    "vwap": 0,
    "filled": 0,
    "status": "Started"
  },
  {
    "id": 667,
    "quantity": 1,
    "price": 10,
    "o_action": "Sell",
    "pair": "btcusd",
    "type": "Limit",
    "vwap": 0,
    "filled": 0,
    "status": "Started"
  }
]
```

This endpoint returns an array of statuses for all active orders.

### HTTP Request

`GET /v1/orders`

### Possible "status" values

Value | Description
--------- | -----------
Started | The order is open on the marketplace waiting for fills
Cancel pending | The order is in the process of being cancelled
Canceled | The order was successfully canceled
Filled | The order was filled
Done | The order was completed successfully


## Cancel Order

```shell
curl "https://api.sfox.com/v1/orders/<order_id>" \
  -u "<api_key>:" \
  -X DELETE
```

```python
requests.delete(
    "https://api.sfox.com/v1/orders/<order_id>",
    auth=requests.auth.HTTPBasicAuth("<api_key>", "")
).json()
```

> The above command does not return anything.  To check on the cancellation status of the order you will need to poll the get order status api.

This endpoint will start cancelling the order specified.

### HTTP Request

`DELETE /v1/orders/<order_id>`

## Asset Pairs

```shell
curl "https://api.sfox.com/v1/markets/currency-pairs" \
  -u "<api_key>:" \
  -X GET
```

```python
requests.get(
    "https://api.sfox.com/v1/markets/currency-pairs",
    auth=requests.auth.HTTPBasicAuth("<api_key>", "")
).json()
```

> Response

```json
{
    "bchbtc": {
        "formatted_symbol": "BCH/BTC",
        "symbol": "bchbtc"
    },
    "bchusd": {
        "formatted_symbol": "BCH/USD",
        "symbol": "bchusd"
    },
    "btcusd": {
        "formatted_symbol": "BTC/USD",
        "symbol": "btcusd"
    }
}
```

SFOX allows for you to get a list of the asset pairs that are currently active for your account. Please note that the "symbol" key in each of the asset pair objects is the one that can be used to place buy/sell orders or request marketdata.

### HTTP Request

`GET /v1/markets/currency-pairs`


## Algorithm IDs
ID | Description
--------- | -----------
200 | Smart Routing
301 | Goliath
302 | Tortoise
303 | Hare
304 | Stop-Loss
305 | Polar Bear
306 | Sniper
307 | TWAP

# Websocket
## Connecting
```javascript

  const WebSocket = require('ws');

  const ws = new WebSocket('wss://ws.sfox.com/ws');
  ws.on('message', function(data) {
    // Do something with data
    console.log(data);
  });
```

Connecting to the SFOX websocket allows for you to receive realtime marketdata from the exchanges that SFOX is connected to.

Endpoint | Description
--------- | -----------
Production | wss://ws.sfox.com/ws
Sandbox | [Contact support](mailto:support@sfox.com)

## Managing Subscriptions
> Subscribing

```javascript
  var subscribeMsg = {
    "type": "subscribe",
    "feeds": ["ticker.sfox.btcusd"]
  }
  ws.send(JSON.stringify(subscribeMsg));
```

> Response:

```json
  {
    "type":"success",
    "sequence":1,
    "timestamp":1534443719605160397
  }

  {
    "sequence": 2,
    "recipient": "ticker.sfox.btcusd",
    "timestamp": 1534443725944639261,
    "payload": {
        "amount": 0.0989,
        "exchange": "coinbase",
        "high": 6491.8,
        "last": 6399.99,
        "low": 6200,
        "open": 6269.01,
        "pair": "btcusd",
        "route": "Smart",
        "source": "ticker-info",
        "timestamp": "2018-08-16T18:22:05.909Z",
        "volume": 38541.16966647,
        "vwap": 6358.123642949931
    }
}
```

> Unsubscribing

```javascript
  var unsubscribe = {
          "type": "unsubscribe",
          "feeds": ["ticker.sfox.btcusd"]
      }
  ws.send(JSON.stringify(unsubscribe));
```

> Response:

```json
  {
    "type":"success",
    "sequence":30,
    "timestamp":1534440639383033506
  }
```

Once connected to the SFOX websocket you can subscribe to various public feeds without authenticating by using the `subscribe` or `unsubscribe` command. These commands should be JSON with the following properties.

Property | Type | Description
--------- | ----------- | -----------
type | string | Command you are sending to the websocket (`subscribe` or `unsubscribe`)
feeds | []string | List of the feeds that should be subscribed/unsubscribed to

### Supported Feeds
Type | Feed
--------- | ---------
Ticker | ticker.sfox.btcusd
Ticker | ticker.sfox.ethusd
Ticker | ticker.sfox.bchusd
Ticker | ticker.sfox.ethbtc
Ticker | ticker.sfox.bchbtc
Orderbook | orderbook.sfox.btcusd
Orderbook | orderbook.sfox.ethusd
Orderbook | orderbook.sfox.bchusd
Orderbook | orderbook.sfox.ethbtc
Orderbook | orderbook.sfox.bchbtc
Trades | trades.sfox.btcusd
Trades | trades.sfox.ethusd
Trades | trades.sfox.bchusd
Trades | trades.sfox.ethbtc
Trades | trades.sfox.bchbtc

## Message Format
Messages that are sent to the various feeds will be JSON objects with the following similar format.

Property | Type | Description
--------- | ----------- | -----------
sequence | int | The sequence number that the message was sent in.
recipient | string | The feed that the message was sent to
timestamp | int | The timestamp (in microseconds)
payload | json | The payload parameter will be a JSON message that contains then data

<aside class="notice">
Please note that the `sequence` number sent by the websocket is not guaranteed to be in ascending order. If you detect any gaps or incorrect ordering you should reconnect.
</aside>

### Ticker Message

> Ticker example message

```json
  {
    "sequence": 2,
    "recipient": "ticker.sfox.btcusd",
    "timestamp": 1534440861543042409,
    "payload": {
      "amount": 0.0092443,
      "exchange": "bitstamp",
      "high": 6491.8,
      "last": 6442.5,
      "low": 6200,
      "open": 6269.01,
      "pair": "btcusd",
      "route": "Smart",
      "source": "ticker-info",
      "timestamp": "2018-08-16T17:34:21.000Z",
      "volume": 36810.02514349,
      "vwap": 6355.319029430
    }
  }
```

Subscriptions to the ticker feed will receive realtime trades that occur on any of the exchanges that are active on the SFOX platform.

### Orderbook Message

> Orderbook example

```json
  {
    "sequence": 2,
    "recipient": "orderbook.sfox.ethbtc",
    "timestamp": 1534440609281315077,
    "payload": {
        "bids": [
            [
                0.0454916,
                1.519,
                "market2"
            ],
            [
                0.04549109,
                1.182,
                "market2"
            ],
            [
                0.04549086,
                0.21094215,
                "market2"
            ],
        ],
        "asks": [
            [
                0.04564,
                34.1074,
                "gemini"
            ],
            [
                0.04559969,
                4.8245942,
                "bitstamp"
            ],
            [
                0.04556277,
                0.507,
                "market2"
            ]
        ],
        "exchanges": {
            "gemini": "OK",
            "bitfinex": "OK",
            "bitstamp": "OK",
            "kraken": "DEGRADED",
            "market1": "OK",
            "market2": "OK"
        },
        "lastupdated": 1534440609168,
        "pair": "ethbtc",
        "currency": "btc"
    }
  }
```

Subscriptions to one or many of the orderbook feeds will receive snapshots of the full SFOX orderbook for that pair.

<aside class="notice">
Please note that subscriptions to the orderbook will receive full orderbook snapshots for the pair subscribed to, SFOX does not support sending changes at this time.
</aside>

# FIX Api
For information on how to implement the FIX protocol please contact [support@sfox.com](mailto:support@sfox.com).

# Python example

```python
import requests


class Sfox:
    def __init__(self, api_key=None, endpoint="api.sfox.com", version="v1"):
        self.session = requests.Session()
        if api_key:
            self.session.auth = requests.auth.HTTPBasicAuth(api_key, "")
        self.host = "https://" +  endpoint + "/" + version

    def url_for(self, resource):
        return self.host + "/" + resource

    def _request(self, method, resource, raise_for_status=True, **kwargs):
        r = self.session.request(method.upper(), self.url_for(resource.lower()), **kwargs)
        if raise_for_status:
            r.raise_for_status()
        return r.json()

    def _get(self, resource, params=None):
        return self._request("GET", resource, params=params)

    def _post(self, resource, data=None, json=None):
        return self._request("POST", resource, data=data, json=json)

    def _delete(self, resource):
        return self._request("DELETE", resource)

    # Public Endpoints

    def orderbook(self, market):
        market = market.lower()
        resource = "markets/orderbook/" + market
        return self._get(resource)

    def best_buy_price(self, quantity):
        resp = self._get("offer/buy", params={"amount": quantity})
        return resp["price"]

    def best_sell_price(self, quantity):
        resp = self._get("offer/sell", params={"amount": quantity})
        return resp["price"]

    # Private Endpoints

    def market_buy(self, quantity, pair):
        data = {"quantity": quantity,"currency_pair": pair}
        return self._post("orders/buy", json=data)

    def market_sell(self, quantity, pair):
        data = {"quantity": quantity,"currency_pair": pair}
        return self._post("orders/sell", json=data)

    def limit_buy(self, price, quantity, pair):
        data = {"quantity": quantity, "price": price, "currency_pair": pair}
        return self._post("orders/buy", json=data)

    def limit_sell(self, price, quantity, pair):
        data = {"quantity": str(quantity), "price": str(price), "currency_pair": pair}
        return self._post("orders/sell", json=data)

    def balance(self):
        return self._get("user/balance")

    def get_order_status(self, order_id):
        return self._get("order/" + str(order_id))

    def get_transaction_history(self, from_ts=50, to_ts=0):
        # TODO: update for using timestamps from/to
        return self._get("account/transactions", {"limit": limit, "offset": offset})

    def get_active_orders(self):
        return self._get("orders")

    def cancel_order(self, order_id):
        res = self._delete("order/" + str(order_id))
        order = self.get_order_status(order_id)
        if order["status"] == "Canceled":
            return True
        return False

    def cancel_last_order(self):
        orders = self.get_active_orders()
        if not orders:
            raise ValueError("No active orders to cancel")
        last_order = orders[0]["id"]
        return self.cancel_order(last_order)

    def cancel_all_orders(self):
        canceled = []

        for order in self.get_active_orders():
            if self.cancel_order(order["id"]):
                canceled.append(order["id"])

        return canceled


if __name__ == "__main__":
    import time

    sfox = Sfox("my_sfox_api_key")

    order = sfox.limit_buy(10000, 1, "btcusd")
    for _ in range(10):
        placed_order = sfox.get_order_status(order["id"])
        if placed_order["status"] == "Done":
            print("Order complete")
            break

        time.sleep(6)
    else:
        print("Canceling order", order["id"])
        if sfox.cancel_order(order["id"]):
            print("Order Canceled")
        else:
            print("Order cancellation not confirmed")
```
