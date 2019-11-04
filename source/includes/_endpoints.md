# Endpoints

Endpoint | Description
--------- | -----------
Production | https://api.sfox.com
Sandbox | [Contact support](mailto:support@sfox.com)

# Authentication

> To authorize, use this code:

```shell
# With shell, you can just pass the correct header with each request
$ curl -u "<api token>:" api_endpoint_here
```

```python
import requests
auth = requests.auth.HTTPBasicAuth("<api_token>", "")
requests.get("api_endpoint_here", auth=auth)
```

> Make sure to replace <api_key> with your API key, and don't forget the colon in the shell example

SFOX uses API keys to grant access. You can create a new SFOX API key at our [developer portal](https://trade.sfox.com/account/api).

The API key should be included in all API requests to the server in the `Authorization` header that looks like the following:

`Authorization: Bearer <api_key>`

<aside class="notice">
    You must replace `api_key` with your personal API key.
</aside>

# Price Data

## Get Best Price

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
quantity | The amount to buy or sell
vwap | "Volume Weighted Average Price", the price the user can expect to receive if the order is executed. Even though the price is $383.21 in this example, you will most likely pay $383 for the entire order. These prices are not guaranteed as the market is always moving.
price | the limit price the user must specify to achieve the VWAP price at execution
fees | the expected fee for executing this order
total | the total cost of the order

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

Get the blended L2 orderbook data of our connected exchanges, including the top bids and asks and the location of those bids and asks.

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

# User

## Get Account Balance

```shell
$ curl "https://api.sfox.com/v1/user/balance" \
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

`GET /v1/user/balance`

### Response Body

Key | Description
--- | -----------
currency |
balance | Amount of the currency in an account (available + held)
available | Amount of the currency available for trading
held | Amount of the currency "on hold"
WalletTypeId | _ignore_

## Get Transaction History

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

Use this endpoint to access your transaction history, including trades and transfers. It returns an array of objects, each of which has details for each individual transaction.

### HTTP Request

`GET /v1/account/transactions`

### Query Parameters

Parameter | Default | Description
--------- | ------- | -----------
from | 0 | Starting timestamp (in millis)
to | utcnow | Ending timestamp (in millis)

### Response Body

This endpoint returns an array of objects, each of which has the details of the transaction:

Key | Example | Description
--- | ----------- | -----------
id | | Transaction ID
order\_id | | Order ID, if applicable
client\_order\_id | | The order ID that the client requested via a [new order](#TODO)
day | 2019-07-31T17:26:30.000Z | The timestamp of the transaction, in ISO8601 format
action | Deposit | The action, this can be one of "Deposit", "Buy", ...??? TODO
currency | btc | The base currency
memo | |
amount | 0.00262916 | Amount of the transaction of the `currency`
net\_proceeds | | Net amount after fees
price | | Price per unit of the base `currency`
fees | | Amount of fees paid in the transaction
status | |
hold\_expires | |
tx\_hash | |
algo\_name | |
algo\_id | |
account\_balance | |
AccountTransferFee | |
Description | |
wallet\_display\_id | | |

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

