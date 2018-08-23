# Orders

## Buy (Market Order)

```shell
curl "https://api.sfox.com/v1/orders/buy" \
  -u "<api_key>:" \
  -d "quantity=1" \
  -d "currency_pair=btcusd"
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

### Query Parameters

Parameter | Description
--------- | -----------
quantity | the amount of crypto assets you wish to buy


## Buy (Limit Order)

```shell
curl "https://api.sfox.com/v1/orders/buy" \
  -u "<api_key>:" \
  -d "quantity=1" \
  -d "price=10" \
  -d "currency_pair=btcusd"
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
price | the max price you are willing to pay.  The executed price will always be less than or equal to this price if the market conditions allow it, otherwise the order will not execute.
algorithm_id | the [algorithm id](#algorithm-ids) you wish to use to execute the order (default: 200) 
client_order_id | this is an optional field that will hold a user specified id for reference
currency_pair | the asset pair you wish to trade (default: btcusd)


## Sell (Market Order)

```shell
curl "https://api.sfox.com/v1/orders/sell" \
  -u "<api_key>:" \
  -d "quantity=1" \
  -d "currency_pair=btcusd"
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

### Query Parameters

Parameter | Description
--------- | -----------
quantity | the amount of crypto assets you wish to buy

## Sell (Limit Order)

```shell
curl "https://api.sfox.com/v1/orders/sell" \
  -u "<api_key>:" \
  -d "quantity=1" \
  -d "price=10" \
  -d "currency_pair=btcusd"
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

### Query Parameters

Parameter | Description
--------- | -----------
quantity | the amount of crypto assets you wish to buy
price | the min price you are willing to accept.  The executed price will always be higher than or equal to this price if the market conditions allow it, otherwise the order will not execute.
algorithm_id | the [algorithm id](#algorithm-ids) you wish to use to execute the order (default: 200) 
client_order_id | this is an optional field that will hold a user specified id for reference
currency_pair | the asset pair you wish to trade (default: btcusd)




## Get Order Status

```shell
curl "https://api.sfox.com/v1/order/<order_id>" \
  -u "<api_key>:"
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

This endpoint returns the status of the order specified by the <order_id> url parameter

### HTTP Request

`GET /v1/order/<order_id>`

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
curl "https://api.sfox.com/v1/order/<order_id>" \
  -u "<api_key>:" \
  -X DELETE
```

> The above command does not return anything.  To check on the cancellation status of the order you will need to poll the get order status api.

This endpoint will start cancelling the order specified.

### HTTP Request

`DELETE /v1/order/<order_id>`

## Asset Pairs
```shell
curl "https://api.sfox.com/v1/markets/currency-pairs" \
  -u "<api_key>:" \
  -X GET
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

