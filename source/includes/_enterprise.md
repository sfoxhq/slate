# Enterprise

## Streaming Quotes
> Authentication message: 

```json
{
    "type": "authenticate",
    "api_key": "<your_api_key>",
}
```

> Subscribe message:

```json
{
    "type": "subscribe",
    "feeds": ["private.orderbook.compact.btcusd"],
}
```

> Unsubscribe message:

```json
{
    "type": "unsubscribe",
    "feeds": ["private.orderbook.compact.btcusd"],
}
```

For Enterprise clients, SFOX offers a customizable compact orderbook of real-time executable quotes. Execution is not guaranteed.

### Connecting

Streaming Quotes are accessible from the SFOX websocket feed.

Endpoint | Description
-------- | -----------
Production | wss://ws.sfox.com/ws
Sandbox | Contact Support

### Authenticating and Subscribing

Once connected to the SFOX websocket, you must authenticate with your API key before subscribing to private feeds.

#### Authentication
Property | type | Command
-------- | ---- | -------
type | string | “authenticate”
apiKey | string | “your-api-key”

#### Subscribing/Unsubscribing

Property | type | Command
-------- | ---- | -------
type | string | “subscribe” or "unsubscribe"
feeds | []string | “your-api-key”
