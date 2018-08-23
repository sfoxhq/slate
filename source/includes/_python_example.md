# Python example
## Public API
```python
import json
import time
import requests

class Sfox:
    def __init__(self, endpoint="api.sfox.com", version="v1"):
        self.endpoint = endpoint.lower()
        self.apiVersion = version.lower()

    def url_for(self, resource):
        return "https://" + self.endpoint + "/" + self.apiVersion + "/" + resource

    def get(self, resource, apiKey=None):
        resource = resource.lower()
        auth = None
        if apiKey:
            auth = requests.auth.HTTPBasicAuth(apiKey, "")
        url = self.url_for(resource)
        return requests.get(url, auth=auth)

    def orderbook(self, market):
        market = market.lower()
        resource = "markets/orderbook/"+market
        res = self.__get(resource)
        return json.loads(res.text)
   
    def bestBuyPrice(self, quantity):
        resource = "offer/buy?amount="+str(quantity)
        res = self.__get(resource)
        data = json.loads(res.text)
        return data["price"]

    def bestSellPrice(self, quantity):
        resource = "offer/sell?amount="+str(quantity)
        res = self.__get(resource)
        data = json.loads(res.text)
        return data["price"]
```

## Private API
```python
class PrivateSfox(Sfox):
    def __init__(self, api_key, endpoint="api.sfox.com", version="v1"):
        self.endpoint = endpoint
        self.apiVersion = version
        self.api_key = api_key
        super().__init__(endpoint, version)

    def post(self, resource, data):
        resource = resource.lower()
        url = self.url_for(resource)
        return requests.post(
            url,
            data = data, 
            auth = requests.auth.HTTPBasicAuth(self.api_key,"")
        )

    def get(self, resource):
        return super().get(resource, self.api_key)

    def delete(self, resource):
        url = self.url_for(resource)
        return requests.delete(
            url, 
            auth = requests.auth.HTTPBasicAuth(self.api_key,"")
        )
    
    def market_buy(self, quantity, pair):
        data = {"quantity": str(quantity),"currency_pair":str(pair)}
        res = self.post("orders/buy", data)
        return json.loads(res.text)
    
    def market_sell(self, quantity, pair):
        data = {"quantity": str(quantity),"currency_pair": str(pair)}
        res = self.post("orders/sell", data)
        return json.loads(res.text)
    
    def limit_buy(self, price, quantity, pair):
        data = {"quantity": str(quantity), "price": str(price), "currency_pair":str(pair)}
        res = self.post("orders/buy", data)
        return json.loads(res.text)
    
    def limit_sell(self, price, quantity, pair):
        data = {"quantity": str(quantity), "price": str(price), "currency_pair":str(pair)}
        res = self.post("orders/sell", data)
        return json.loads(res.text)         
  
    def balance(self):
        res = self.get("user/balance")
        return json.loads(res.text)

    def get_order_status(self,order_id):
        res = self.get("order/" + str(order_id))
        return json.loads(res.text)
    
    def get_trade_history(self, limit, offset):
        res = self.get("account/transactions?limit=" + str(limit) + "&offset=" + str(offset))
        return json.loads(res.text)

    def get_active_orders(self):
        res = self.get("orders")
        return json.loads(res.text)

    def cancel_order(self,order_id):
        res = self.delete("order/" + str(order_id))
        order = self.get_order_status(order_id)
        if order["status"] == "Canceled":
            return True
        return False

    def cancel_last_order(self):
        orders = self.get_active_orders()
        last_order = orders[0]["id"]
        return self.cancel_order(last_order)

    def cancel_all_orders(self):
        orders = self.get_active_orders()
        targetList = []
        canceled = []

        for order in orders:
            targetList.append(order["id"])

        for myId in targetList:
            if self.cancel_order(myId):
                canceled.append(myId)  
        return canceled
```
