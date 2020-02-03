# Orders

## Place an Order

You can place eight types of orders, specified by an [Algorithm ID](#algorithm-ids). Orders can only be placed if your account has sufficient funds. Once an order is placed, your account funds will be put _on hold_ for the duration of the order. How much and which funds are put on hold depends on the order type and parameters specified.

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
    json={
        "quantity": 1,
        "currency_pair": "<currency_pair>"
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

### HTTP Request

`POST /v1/orders/buy` or `POST /v1/orders/sell`

### Common Parameters
These parameters are common to all order creation requests. See [Special Parameters](#special-parameters) for exceptions.

Parameter | Default | Description
--------- | ------- | -----------
quantity |  | The quantity to trade. The minimum quantity is 0.001 for crypto-denominated pairs, and price*quantity must be greater than $5 for USD-denominated pairs.
currency\_pair | btcusd | The pair or product to trade.
price | | The limit price (Precision: 8 decimal places for crypto, 2 decimal places for fiat). **Note: the executed price will always be better than or equal to this price; if the market conditions do not allow it, the order will not execute.** 
algorithm\_id | 200 | Specifies the [algorithm](#algorithm-ids) you wish to use to execute the order.
routing\_type | Smart | How SFOX will route your order. For more info, see [Routing Types](#routing-types).
client\_order\_id | | An optional field that can hold a user-specified ID.

### Special Parameters
Some of SFOX's algorithms require different parameters that define execution. 

Parameter | Algorithms | Default | Description
--------- | -------- | ------- | -----------
amount | Market | | The amount (quote currency) to spend when buying. **Note: required if and only if the order is a market buy - in this case, quantity is not required and is ignored**.
interval | TWAP | 900 | The frequency at which TWAP trades are executed (in seconds).
total\_time | TWAP | | The maximum time a TWAP order will stay active (in seconds). Must be >= 15 minutes and the interval.

<aside class="warning">
    If no price is specified for an order (other than Market, Instant, and Simple types), the order will be rejected.
</aside>
<aside class="notice">
    Orders placed without an Algorithm ID will default to Limit.
</aside>

## Cancel an Order

This endpoint will start cancelling the order specified.

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

> The above command does not return anything. To determine the cancellation status of an order, you will need to poll the Order Status endpoint.

### HTTP Request

`DELETE /v1/orders/<order_id>`

## Order Status

Get the status and details of an order.

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

> The above command returns a JSON object structured like this:

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



## Get Open Orders

Get a list of your current open orders.

```shell
curl "https://api.sfox.com/v1/orders" \
  -u "<api_key>:"
```

```python
requests.get(
    "https://api.sfox.com/v1/orders",
    auth=requests.auth.HTTPBasicAuth("<api_key>", "")
).json()
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

## List Asset Pairs

Get a list of the asset pairs that are currently active for your account.

<aside class="notice">
    The "symbol" key in each asset pair is the one that can be used to place orders and request market data.
</aside>

```shell
curl "https://api.sfox.com/v1/markets/currency-pairs" \
  -u "<api_key>:"
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

### HTTP Request

`GET /v1/markets/currency-pairs`