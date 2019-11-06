# Python example

```python
import time

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

    def get_transaction_history(self, from_ts=0, to_ts=None):
        if to_ts is None:
            to_ts = int(time.time() * 1000)
        return self._get("account/transactions", {"from": from_ts, "to": to_ts})

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
