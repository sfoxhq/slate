# Algorithms & Routing Types    
## Algorithms
SFOX offers a wide range of trading algorithms, as well as two routing types, to optimize your order's execution. For more details, see [SFOX Algorithms](https://www.sfox.com/algos.html).

ID | Name | Routing Types | Description
--------- | ----------- | --------- | ---------
100 | Market | [Smart, NetPrice] | Optimally-routed market order (taker-only)
150 | Instant | N/a | Instantly-settled market order
160 | Simple | N/a | Instantly-settled market order
200 | Smart Routing | [Smart, NetPrice] | Smart order routing
201 | Limit | [Smart, NetPrice] | Optimally-routed limit order
301 | Gorilla | [Smart] | Hidden, smart-routed order, optimized for larger order sizes (maker-only)
302 | Tortoise | [Smart] | API ONLY - places once on the best exchange (maker-only)
303 | Hare | [Smart] | Smart-routed order (maker-only)
304 | Stop-Loss | [Smart, NetPrice] | Smart-routed trigger order (taker-only)
305 | Polar Bear | [Smart, NetPrice] | Hidden, optimally-routed less-aggressive order (taker-only)
306 | Sniper | [Smart, NetPrice] | Hidden, optimally-routed agressive order (taker-only)
307 | TWAP | [Smart, NetPrice] | Optimally-routed order for trading over a period of time at a specified limit price (taker-only)

## Routing Types
The routing type defines how SFOX prioritizes different sources of liquidity when executing your order. SFOX always attempts to execute your order at the best available price.

Routing Type | Description
----------------- | -----------
NetPrice | Routes orders to the best venues for execution by considering both the quoted prices and the fees charged by the trading venues. Orders can be routed to additional OTC trading venues and receive a 10bps discount on the SFOX fee. For more details, see [here](https://blog.sfox.com/sfox-pricing-crypto-trading-net-price-routing-8997fbc0520).

<aside class="notice">
    Contact <a href="mailto:support@sfox.com">support@sfox.com</a> to learn more about additional routing options.
</aside>