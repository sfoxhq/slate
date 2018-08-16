---
title: API Reference

language_tabs:
  - shell

toc_footers:
  - <a href='/account/api'>Sign Up for a Developer Key</a>
  - <a href='mailto:support@sfox.com'>Need help? Email us</a>

includes:
  - errors

search: true
---

# Introduction

Welcome to the SFOX API! The API allows you to connect your application to SFOX, execute trades, and deposit and withdraw currencies.

# Authentication

> To authorize, use this code:

```shell
# With shell, you can just pass the correct header with each request
curl "api_endpoint_here"
  -u "<api token>:"
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

`GET https://api.sfox.com/v1/offer/buy?quantity`

### Query Parameters

Parameter | Default | Description
--------- | ------- | -----------
quantity||The number of bitcoin you will be trading


## Get Orderbook

```shell
curl "https://api.sfox.com/v1/markets/orderbook/<market_of_choice>"
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

`GET https://api.sfox.com/v1/markets/orderbook`

### Query Parameters

Parameter | Default | Description
--------- | ------- | -----------
NONE

# User

## Get Account Balance

```shell
curl "https://api.sfox.com/v1/user/balance"
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

Use this endpoint to access your account balance.  It returns an array of objects, each of which has details for a single currency.  

You will get Balance and Available balance.  Balance is your total balance for this currency.  Available, on the other hand, is what is available to you to trade and/or withdraw.  The difference is amount that is reserved either in an open trade or pending a withdrawal request.

### HTTP Request

`GET https://api.sfox.com/v1/balance`

### Query Parameters

Parameter | Default | Description
--------- | ------- | -----------
NONE

## Get Trade History

```shell
curl "https://api.sfox.com/v1/account/transactions?limit=250&offset=0"
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

`GET https://api.sfox.com/v1/account/transactions?limit=250&offset=0`

### Query Parameters

Parameter | Default | Description
--------- | ------- | -----------
NONE



## Request an ACH deposit

```shell
curl "https://api.sfox.com/v1/user/withdraw"
  -H "Authorization: <api_key>"
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

`POST https://api.sfox.com/v1/user/deposit`

### Form Parameters

Parameter | Description
--------- | -----------
amount | The amount you wish to deposit from your bank account


## Withdraw Funds

```shell
curl "https://api.sfox.com/v1/user/withdraw"
  -H "Authorization: <api_key>"
  -d "amount=1"
  -d "address="
  -d "currency=usd"
```

> The above command returns JSON structured like this:

```json
{
  "success": true
}
```

Submits a coin or currency withdrawal request to SFOX.  Your funds must be available before requesting withdrawal.  For fiat currency withdrawal, your bank account must be setup prior to making the withdrawal request.  You can setup your bank account by going to [Accounts / Deposits](https://api.sfox.com/#/account/deposit).

<aside class="notice">If the request fails, the json result will include an error field with the reason.</aside>

### HTTP Request

`POST https://api.sfox.com/v1/user/withdraw`

### Form Parameters

Parameter | Description
--------- | -----------
amount | The amount you wish to withdraw
currency | Currency is one of: usd or btc
address | if currency == btc this field has to be a valid mainnet bitcoin address. Otherwise leave it out or empty


# Orders

## Buy Now

```shell
curl "https://api.sfox.com/v1/orders/buy"
  -u "<api_key>:"
  -d "quantity=1"
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

This is a market order request to buy certain quantity of bitcoin.  Since this is a "Buy Now" order, it will execute immediately.

### HTTP Request

`POST https://api.sfox.com/v1/orders/buy`

### Query Parameters

Parameter | Description
--------- | -----------
quantity | the amount of bitcoin you wish to buy


## Buy Bitcoin

```shell
curl "https://api.sfox.com/v1/orders/buy"
  -u "<api_key>:"
  -d "quantity=1"
  -d "price=10"
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

This endpoint initiates a buy order for bitcoin for the specified amount with the specified limit price.  If the price field is omitted, then the order will be treated as a market order and will execute immediately.  If there is an issue with the request you will get the reason in the "error" field.

### HTTP Request

`POST https://api.sfox.com/v1/orders/buy`

### Query Parameters

Parameter | Description
--------- | -----------
quantity | the amount of bitcoin you wish to buy
price | the max price you are willing to pay.  The executed price will always be less than or equal to this price if the market conditions allow it, otherwise the order will not execute.
algorithm_id | the [algorithm id](#algorithm-ids) you wish to use to execute the order (default: 200) 
client_order_id | this is an optional field that will hold a user specified id for reference
currency_pair | the currency pair you wish to trade (default: btcusd)


## Sell Now

```shell
curl "https://api.sfox.com/v1/orders/sell"
  -u "<api_key>:"
  -d "quantity=1"
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
This is a market order request to sell certain quantity of bitcoin.  Since this is a "Sell Now" order, it will execute immediately.


### HTTP Request

`POST https://api.sfox.com/v1/orders/sell`

### Query Parameters

Parameter | Description
--------- | -----------
quantity | the amount of bitcoin you wish to buy

## Sell Bitcoin

```shell
curl "https://api.sfox.com/v1/orders/sell"
  -u "<api_key>:"
  -d "quantity=1"
  -d "price=10"
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

This endpoint initiates a sell order for bitcoin for the specified amount with the specified limit price.  If the price field is omitted, then the order will be treated as a market order and will execute immediately.  If there is an issue with the request you will get the reason in the "error" field.

### HTTP Request

`POST https://api.sfox.com/v1/orders/sell`

### Query Parameters

Parameter | Description
--------- | -----------
quantity | the amount of bitcoin you wish to buy
price | the min price you are willing to accept.  The executed price will always be higher than or equal to this price if the market conditions allow it, otherwise the order will not execute.
algorithm_id | the [algorithm id](#algorithm-ids) you wish to use to execute the order (default: 200) 
client_order_id | this is an optional field that will hold a user specified id for reference
currency_pair | the currency pair you wish to trade (default: btcusd)




## Get Order Status

```shell
curl "https://api.sfox.com/v1/order/<order_id>"
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

`GET https://api.sfox.com/v1/order/<order_id>`

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
curl "https://api.sfox.com/v1/orders"
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

`GET https://api.sfox.com/v1/orders`

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
curl "https://api.sfox.com/v1/order/<order_id>"
  -u "<api_key>:"
  -X DELETE
```

> The above command does not return anything.  To check on the cancellation status of the order you will need to poll the get order status api.

This endpoint will start cancelling the order specified.

### HTTP Request

`DELETE https://api.sfox.com/v1/order/<order_id>`

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

# Python Wrapper

Features
------------

* **SFOX Python Wrapper: Public API, Private API, Strategy**

* **PubliC API** 
  - **Connect to SFOX Rest API**
  - **Raw Orderbook**
  - **Live Orderbook**
  - **Best Buy Price**
  - **Best Sell Price**
                 
* **Private API** 
  - **Connect to Private API. PrivateSfox('#Enter API Key')** 
  - **Balance**
  - **getOrderStatus**
  - **getTradeHistory**
  - **getActiveOrders**
  - **cancelOrder**
  - **CancelLastOrder**
  - **CancelAllOrders**
                  
* **Strategy** 
  - **Connect to Public and Private API. Strategy('#Enter API Key')**
  - **Arbitrage bot: will get snapshot of the orderbooks of any given market, connect to private API, and execute any arbitrage opportunity if exists**
  - **Spread Strategy: Framework for executing a spread strategy.  Choose two markets, will provide continously running orderbooks**
               


![Alt text](https://raw.githubusercontent.com/lmontealegre24/slate/master/source/images/Capture.PNG)


```shell

import urllib
from urllib.request import urlopen
import json
import time
import requests
import pandas as pd
from datetime import datetime as dt
from requests.auth import HTTPBasicAuth
from IPython.display import display, HTML, clear_output


# Python 3: Jupyter Notebook

#Public API
class Sfox:
        
    def __init__(self, config={'endpoint': "api.sfox.com", 'version': "v1"}):
        self.endpoint = config['endpoint']
        self.apiVersion = config['version']

    def urlFor(self,resource):
        return "https://" + self.endpoint + "/" + self.apiVersion + "/" + resource

    def rawbook(self,market):
        ret = urlopen(self.urlFor("markets/orderbook/")+ market)
        return json.loads(ret.read())
    
    def liveorderbook(self, market):
        while True:
            timestamp=(str(dt(time.localtime().tm_year, time.localtime().tm_mon, time.localtime().tm_mday, 
                              time.localtime().tm_hour, time.localtime().tm_min, time.localtime().tm_sec)))
            price= Sfox.rawbook(market)
            buyers= pd.DataFrame(price['bids'], columns=['Bid Price','Bid Size','Bid Exchange'])
            buyers['Bid Notional']=buyers['Bid Price']*buyers['Bid Size']
            sellers= pd.DataFrame(price['asks'], columns=['Sell Price','Sell Size','Sell Exchange'])
            sellers['Sell Notional']=sellers['Sell Price']*sellers['Sell Size']

            orderbook= pd.concat([buyers,sellers], axis=1)
            orderbook=orderbook[['Bid Price','Bid Size','Sell Price','Sell Size','Bid Exchange','Bid Notional',
                             'Sell Exchange', 'Sell Notional']]
            print("Orderbook:",market, "Time:", timestamp)
            display(HTML(orderbook.to_html()))
            time.sleep(1)
            clear_output(wait=True)
   
    #split GetBestPrice from API reference page (https://www.sfox.com/developers/#price-data)
    def bestBuyPrice(self,quantity):
        ret = urlopen(self.urlFor("offer/buy?amount=")+ str(quantity))
        print("Buy")
        return json.loads(ret.read())

    def bestSellPrice(self,quantity):
        ret = urlopen(self.urlFor("offer/sell?amount=")+ str(quantity))
        print("Sell")
        return json.loads(ret.read())
        
        
        

#Private API
    
class PrivateSfox():

    def __init__(self, APIKey, config={'endpoint': "api.sfox.com", 'version': "v1"}):
        self.endpoint = config['endpoint']
        self.apiVersion = config['version']
        self.APIKey = APIKey

    def urlFor(self,resource):
        return "https://" + self.endpoint + "/" + self.apiVersion + "/" + resource
    
    def market_buy(self,quantity,pair):
        ret = requests.post(self.urlFor("orders/buy"), data={'quantity': str(quantity),'currency_pair':str(pair)}, 
                            auth=HTTPBasicAuth(self.APIKey,''))
        return json.loads(ret.text)
    
    def market_sell(self,quantity,pair):
        ret = requests.post(self.urlFor("orders/sell"), data={'quantity': str(quantity),'currency_pair':str(pair)}, 
                            auth=HTTPBasicAuth(self.APIKey,''))
        return json.loads(ret.text)
    
    def limit_buy(self,quantity,price,pair):
        ret = requests.post(self.urlFor("orders/buy"), data={'quantity': str(quantity), 'price': str(price),
                            'currency_pair':str(pair)}, auth=HTTPBasicAuth(self.APIKey,''))
        return json.loads(ret.text)
    
    def limit_sell(self,quantity,price,pair):
        ret = requests.post(self.urlFor("orders/sell"), data={'quantity': str(quantity), 'price': str(price),
                            'currency_pair':str(pair)}, auth=HTTPBasicAuth(self.APIKey,''))
        return json.loads(ret.text)
    
        
    #Account API
    
  
    def balance(self):
        ret = requests.get(self.urlFor("user/balance"), auth=HTTPBasicAuth(self.APIKey,''))
        return json.loads(ret.text)
    
# "balance"-  raw data above, placed into pandas below
#         balance=json.loads(ret.text)
#         balance=pd.DataFrame(balance,columns=['currency','available','balance','held'])
#         portfolio=balance.set_index('currency')
#         return portfolio

    def getOrderStatus(self,order_id):
        ret = requests.get(self.urlFor("order/")+ str(order_id), auth=HTTPBasicAuth(self.APIKey,''))
        return json.loads(ret.text)
    
    def getTradeHistory(self):
        ret = requests.get(self.urlFor("account/transactions?limit=250&offset=0"), auth=HTTPBasicAuth(self.APIKey,''))
        return json.loads(ret.text)
    
    
# "getTradeHistory"- raw data above, placed into pandas below
#         trades=json.loads(ret.text)
#         print("Raw API:\n", trades)
#         trade_hist=pd.DataFrame(trades, columns=['action','price','amount','currency','day','fees','id'])
#         return trade_hist
    
    def getActiveOrders(self):
        ret = requests.get(self.urlFor("orders"), auth=HTTPBasicAuth(self.APIKey,''))
        return json.loads(ret.text)
    
    
    def cancelOrder(self,order_id):
        ret = requests.delete('https://api.sfox.com/v1/order/'+ str(order_id), auth=HTTPBasicAuth(self.APIKey,''))
        order=self.getOrderStatus(order_id)
        if order['status'] == 'Canceled':
            print("Order Canceled")
        else:
            print("Did NOT Cancel")
        return json.loads(ret.text)
    
    def cancelLastOrder(self):
        orders=self.getActiveOrders()
        last_order=orders[0]['id']
        self.cancelOrder(last_order)
        return
    
    def cancelAllOrders(self):
        order=self.getActiveOrders()
        ids=[]
        print(len(order),"orders cancelled")
        for i in range(len(order)):
            ids.append(order[i]['id'])
        for i in range(len(ids)):
            self.cancelOrder(ids[i])
    
        
    
#Algorithms/Trade API 
 
        
class Strategy():   
    
    def __init__(self, APIKey, config={'endpoint': "api.sfox.com", 'version': "v1"}):
        self.endpoint = config['endpoint']
        self.apiVersion = config['version']
        self.APIKey = APIKey
    
    def arb_snipe(self, market, show=False):
        price= Sfox().rawbook(market)
        buyers= pd.DataFrame(price['bids'], columns=['Bid Price','Bid Size','Bid Exchange'])
        buyers['Bid Notional']=buyers['Bid Price']*buyers['Bid Size']
        sellers= pd.DataFrame(price['asks'], columns=['Sell Price','Sell Size','Sell Exchange'])
        sellers['Sell Notional']=sellers['Sell Price']*sellers['Sell Size']

        orderbook= pd.concat([buyers,sellers], axis=1)
        orderbook['Sell Fee (per btc)']=(orderbook['Sell Price']*.0025)
        orderbook['Buy Fee (per btc)']=(orderbook["Bid Price"]*.0025)
        orderbook["Arb $ (per btc)"]= orderbook["Bid Price"]-orderbook['Sell Price'] 
        
        arb_orderbook = orderbook[orderbook['Arb $ (per btc)'] > orderbook['Buy Fee (per btc)']+orderbook['Sell Fee (per btc)']]

        while len(arb_orderbook) > 0 :
            print("Arb exists")
            order_size= min(orderbook['Sell Size'][0],orderbook['Bid Size'][0])
            buy_side=min(orderbook['Bid Price'][0],orderbook['Sell Price'][0])
            sell_side=max(orderbook['Bid Price'][0],orderbook['Sell Price'][0])
            print("Selling",sell_side-orderbook['Sell Fee'][0])
            print("Buying",buy_side+orderbook['Buy Fee'][0])
            print("Arbitrage after fees (per btc):", sell_side-orderbook['Sell Fee'][0]-buy_side-orderbook['Buy Fee'][0])
            self.market_buy(order_size)
            self.market_sell(order_size)

        else:
            print("No Arb opportunities")
        
        if show==True:
            display(HTML(orderbook.to_html()))

    
    def live_spread_strategy(self,beta,market1,market2, Trade=False):
        
        balance=PrivateSfox(self.APIKey).balance()
        balance=pd.DataFrame(balance,columns=['currency','available','balance','held'])
        port=balance.set_index('currency')
        
        holdings={}
        for cryptos in port.index:
            holdings[cryptos]=port.loc[cryptos]['balance']

        while True:
            timestamp=(str(dt(time.localtime().tm_year, time.localtime().tm_mon, time.localtime().tm_mday, 
                              time.localtime().tm_hour, time.localtime().tm_min, time.localtime().tm_sec)))
            buy_mkt1=Sfox().rawbook(market1)['asks']
            sell_mkt1=Sfox().rawbook(market1)['bids']
            buy_mkt2=Sfox().rawbook(market2)['asks']
            sell_mkt2=Sfox().rawbook(market2)['bids']


            spread= pd.DataFrame((buy_mkt1), columns=[str(market1)+' Asks','Size','Exchange'])
            spread2= pd.DataFrame((sell_mkt1), columns=[str(market1)+' Bids','Size','Exchange'])
            spread3= pd.DataFrame((buy_mkt2), columns=[str(market2)+' Asks','Size','Exchange'])
            spread4= pd.DataFrame((sell_mkt2), columns=[str(market2)+' Bids','Size','Exchange'])

            spreads=pd.concat([spread,spread2,spread3,spread4],axis=1)
            spreads['Buy Spread']=spreads[str(market1)+' Asks']-spreads[str(market2)+' Bids']*beta
            spreads['Sell Spread']=spreads[str(market1)+' Bids']-spreads[str(market2)+' Asks']*beta
            print("Inventory", holdings)
            print("Time:", timestamp)
            display(HTML(spreads.to_html()))
            time.sleep(0.5)
            clear_output(wait=True)
        if Trade==True:
            print('Run your spread strategy: Place execution strategy here')
'''


