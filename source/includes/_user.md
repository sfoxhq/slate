# User

## Get Account Balance

```shell
curl "https://api.sfox.com/v1/user/balance" \
  -u "<api_key>:"
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

### Query Parameters

Parameter | Default | Description
--------- | ------- | -----------
NONE

## Get Trade History

```shell
curl "https://api.sfox.com/v1/account/transactions?limit=250&offset=0" \
  -u "<api_key>:"
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

`GET /v1/account/transactions?limit=250&offset=0`

### Query Parameters

Parameter | Default | Description
--------- | ------- | -----------
NONE



## Request an ACH deposit

```shell
curl "https://api.sfox.com/v1/user/withdraw" \
  -H "Authorization: <api_key>" \
  -d "amount=1"
```

> The above command returns JSON structured like this:

```json
{
  "success": true
}
```

You can transfer funds from your bank account to SFOX using ACH.  You have to setup your bank account by going to [Accounts / Deposits](https://api.sfox.com/#/account/deposit).  Once you have setup your bank account, you can use this call to initiate the transfer request.

<aside class="notice">If the request fails, the json result will include an error field with the reason.</aside>

### HTTP Request

`POST /v1/user/deposit`

### Form Parameters

Parameter | Description
--------- | -----------
amount | The amount you wish to deposit from your bank account


## Withdraw Funds

```shell
curl "https://api.sfox.com/v1/user/withdraw" \
  -H "Authorization: <api_key>" \
  -d "amount=1" \
  -d "address=" \
  -d "currency=usd"
```

> The above command returns JSON structured like this:

```json
{
  "success": true
}
```

Submits an asset withdrawal request to SFOX.  Your funds must be available before requesting withdrawal.  For fiat currency withdrawal, your bank account must be setup prior to making the withdrawal request.  You can setup your bank account by going to [Accounts / Deposits](https://api.sfox.com/#/account/deposit).

<aside class="notice">If the request fails, the json result will include an error field with the reason.</aside>

### HTTP Request

`POST /v1/user/withdraw`

### Form Parameters

Parameter | Description
--------- | -----------
amount | The amount you wish to withdraw
currency | Currency is one of: usd, btc, eth
address | if the "currency" is a crypto asset, this field has to be a valid mainnet address. Otherwise leave it out or empty
