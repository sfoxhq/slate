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

