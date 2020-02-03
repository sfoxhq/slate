# Websocket Feed

## Connecting

```python
import asyncio

import websockets


async def main(uri):
    async with websockets.connect(uri) as ws:
        # don't forget to subscribe (see below)
        async for msg in ws:
            print(msg)


asyncio.run(main("wss://ws.sfox.com/ws"))
```

```javascript
const WebSocket = require('ws');

const ws = new WebSocket('wss://ws.sfox.com/ws');

// don't forget to subscribe (see below)
ws.on('message', function(data) {
    // Do something with data
    console.log(data);
});
```

Connecting to the SFOX websocket feed gives you access to real-time market data from all supported exchanges.

Endpoint | Description
--------- | -----------
Production | wss://ws.sfox.com/ws
Sandbox | [Contact support](mailto:support@sfox.com)

## Subscribing & Unsubscribing

> Subscribing

```python
subscribe_msg = {
    "type": "subscribe",
    "feeds": ["ticker.sfox.btcusd"],
}

await ws.send(json.dumps(subscribe_msg))
```

```javascript
var subscribeMsg = {
    type: "subscribe",
    feeds: ["ticker.sfox.btcusd"]
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

## Supported Channels

### Orderbooks

Orderbook channels are of the form `orderbook.type.pair`. Channels with type `sfox` will stream the normal, consolidated SFOX orderbook, while type `net` channels will stream the fee-adjusted orderbook used for the `NetPrice` routing type.

E.g. `orderbook.sfox.btcusd` or `orderbook.net.ethbtc`

### Trades

Trade channels are of the form `trades.sfox.pair`.

E.g. `trades.sfox.btcusd`

### Ticker

Ticker channels are of the form `ticker.sfox.pair`.

E.g. `ticker.sfox.ltcbtc`

## Channel Descriptions

### Ticker

Receive aggregated 24-hour OHLCV data from all supported exchanges and the last price before each update every 10 seconds. Subscriptions to the ticker feed will receive realtime trades that occur on any of the exchanges that are active on the SFOX platform.

<aside class="notice">
    OHLCV data resets at 00:00 GMT, it is not a rolling period
</aside>

> Ticker Example

```python
import asyncio
import json

import websockets


async def main(uri):
    async with websockets.connect(uri) as ws:
        await ws.send(json.dumps({
            "type": "subscribe",
            "feeds": [
                "ticker.sfox.btcusd",
            ],
        }))
        async for msg in ws:
            print(msg)


asyncio.run(main("wss://ws.sfox.com/ws"))
```

```javascript
const WebSocket = require("ws");
const ws = new WebSocket("wss://ws.sfox.com/ws");

ws.on("message", function(data) {
    console.log(data);
});

ws.on("open", function() {
    ws.send(JSON.stringify({
        type: "subscribe",
        feeds: [
            "ticker.sfox.btcusd"
        ],
    }));
});

```

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

#### Payload Description

Key | Description
--- | -----------
amount | Last trade quantity
exchange | Location of trade
last | Last trade price (tick)
high | 24 hour high price
low | 24 hour low price
open | 24 hour open price
pair | Crypto asset traded
route | disregard
source | Data source
timestamp | Time of trade
volume | 24 hour volume
vwap | 24 hour volume-weighted average price

### Orderbook

Receive real-time L2 orderbook data

> Orderbook Example

```python
import asyncio
import json

import websockets


async def main(uri):
    async with websockets.connect(uri) as ws:
        await ws.send(json.dumps({
            "type": "subscribe",
            "feeds": [
                "orderbook.sfox.ethbtc",
            ],
        }))
        async for msg in ws:
            print(msg)


asyncio.run(main("wss://ws.sfox.com/ws"))
```

```javascript
const WebSocket = require("ws");
const ws = new WebSocket("wss://ws.sfox.com/ws");

ws.on("message", function(data) {
    console.log(data);
});

ws.on("open", function() {
    ws.send(JSON.stringify({
        type: "subscribe",
        feeds: [
            "orderbook.sfox.ethbtc"
        ],
    }));
});

```

> Orderbook Response

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
            ]
            // truncated
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
            // truncated
        ],
        "timestamps": {
            "gemini": [
                1572882771172,
                1572882771176
            ],
            "bitstamp": [
                1572882771112,
                1572882771112
            ],
            "itbit": [
                1572882770106,
                1572882770422
            ],
            "bittrex": [
                1572882769065,
                1572882769115
            ],
            "market1": [
                1572882770515,
                1572882770515
            ]
        },
        "lastupdated": 1534440609168,
        "lastpublished": 1534440609168,
        "pair": "ethbtc",
        "currency": "btc"
    }
  }
```

<aside class="notice">
    Please note that subscriptions to the orderbook will receive full orderbook snapshots for the pair subscribed to, SFOX does not support sending changes at this time.
</aside>

### Trades

Real-time tick data feed of all trades executed on SFOX's supported exchanges

> Trades Example

```python
import asyncio
import json

import websockets


async def main(uri):
    async with websockets.connect(uri) as ws:
        await ws.send(json.dumps({
            "type": "subscribe",
            "feeds": [
                "trades.sfox.btcusd",
            ],
        }))
        async for msg in ws:
            print(msg)


asyncio.run(main("wss://ws.sfox.com/ws"))
```

```javascript
const WebSocket = require("ws");
const ws = new WebSocket("wss://ws.sfox.com/ws");

ws.on("message", function(data) {
    console.log(data);
});

ws.on("open", function() {
    ws.send(JSON.stringify({
        type: "subscribe",
        feeds: [
            "trades.sfox.btcusd"
        ],
    }));
});

```

> Trades Response

```json
{
  "sequence": 2,
  "recipient": "trades.sfox.btcusd",
  "timestamp": 1572883322244910600,
  "payload": {
    "buyOrderId": "4307737868",
    "exchange": "bitstamp",
    "exchange_id": 1,
    "id": "99960684",
    "pair": "btcusd",
    "price": "9300",
    "quantity": "390419",
    "sellOrderId": "4307754886",
    "side": "sell",
    "timestamp": "2019-11-04T16:02:02.000"
  }
}
```

#### Payload Description

Key | Description
--- | -----------
buyOrderId | Order ID of the buy
exchange | Location of the trade
exchange\_id | ID of the trade location
pair | Crypto asset traded
price | Price of the trade
quantity | Quantity traded
sellOrderId | Order ID of the sale
side | Which side was the taker
timestamp | Time of the trade
