# Account Management

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
client\_order\_id | | The order ID that the client requested via a [buy](#place-a-buy-order) or [sell](#place-a-sell-order) order
day | 2019-07-31T17:26:30.000Z | The timestamp of the transaction, in ISO8601 format
action | Deposit | The action, this can be one of "Deposit", "Withdraw", "Buy", "Sell"
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

## Request an ACH transfer

SFOX allows users to transfer funds using ACH. First, set up your bank account by navigating to [Deposit/Withdraw](https://trade.sfox.com/account). Once your account is connected, use this call to initiate the transfer request.

<aside class="notice">
    If the request fails, the json result will include an error field with the reason.
</aside>

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

### HTTP Request

`POST /v1/user/bank/deposit`

### Form/JSON Parameters

Parameter | Description
--------- | -----------
amount | The amount you wish to deposit from your bank account

## Deposit

### List Available Crypto Addresses

List the available crypto asset addresses for deposits to your account.

```shell
curl "https://api.sfox.com/v1/user/deposit/address/{currency}" \
  -H "Authorization: <api_key>"
```

```python
requests.get(
    "https://api.sfox.com/v1/user/deposit/address/{currency}",
    auth=requests.auth.HTTPBasicAuth("<api_key>", ""),
).json()
```

> The above command returns JSON structured list like this:

```json
[
    {
      "address": "<address>",
      "currency": "<currency>"
    },
    {
        "address": "<address>",
        "currency": "<currency>"
    }
]
```

#### HTTP Request

`GET /v1/user/deposit/address/{currency}`

#### Response Body

This returns a list of available addresses to deposit crypto assets

key | description
--- | -----------
address | Crypto address to use for deposits
currency | Crypto asset

### Create a Deposit Address

Generate a new deposit address for the crypto asset of your choosing

> Create a new address

```shell
curl "https://api.sfox.com/v1/user/deposit/address/{currency}" \
  -H "Authorization: <api_key>" \
  -X POST
```

```python
requests.post(
    "https://api.sfox.com/v1/user/deposit/address/{currency}",
    auth=requests.auth.HTTPBasicAuth("<api_key>", ""),
).json()
```

#### HTTP Request

`POST /v1/user/deposit/address/{currency}`

#### Form Parameters

Parameter | Description
--------- | -----------
currency | Currency of choice: btc, bch, eth, ltc, bsv, etc

#### Response Body

Key | Description
--- | -----------
address | Created crypto address
currency | Crypto asset

## Withdraw

Initiate a withdrawal from your SFOX account.

<aside class="notice">
    Your funds must be available before a withdrawal can be initiated. For a fiat withdrawal, you must have a bank account added to your SFOX account. You can connect a bank account by navigating to <a href="https://trade.sfox.com/account">Deposit/Withdraw</a>.
    <br/><br/>
    If the request fails, the JSON result will include an error field with the reason.
</aside>

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
    json={
        "amount": 1,
        "address": "<address if crypto>",
        "currency": "<currency>"
    }
).json()
```

> The above command returns JSON structured like this:

```json
{
  "success": true
}
```

### HTTP Request

`POST /v1/user/withdraw`

### Form/JSON Parameters

Parameter | Description
--------- | -----------
amount | The amount you wish to withdraw
currency | Currency is one of: usd, btc, eth
address | If the "currency" is a crypto asset, this field has to be a valid mainnet address. Otherwise leave it out or empty
