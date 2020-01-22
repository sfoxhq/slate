# Algorithms & Routing Types    
## Algorithms
SFOX offers a wide range of trading algorithms, as well as two routing types, to optimize your order's execution. For more details, see [SFOX Algorithms](https://www.sfox.com/algos.html).

ID | Name | Routing Types | Description
--------- | ----------- | --------- | ---------
100 | Market | [Smart, NetPrice] | Optimally-routed market order (taker-only)
200 | Smart Routing | [Smart, NetPrice] | Basic order routing
201 | Limit | [Smart, NetPrice] | Optimally-routed limit order
301 | Gorilla | [Smart] | Hidden, smart-routed order for large size (maker-only)
302 | Tortoise | [Smart] | Slow-moving, smart-routed order (maker-only)
303 | Hare | [Smart] | Smart-routed order (maker-only)
304 | Stop-Loss | [Smart, NetPrice] | Smart-routed trigger order (taker-only)
305 | Polar Bear | [Smart, NetPrice] | Hidden, optimally-routed, slow-moving order (taker-only)
306 | Sniper | [Smart, NetPrice] | Hidden, optimally-routed order (taker-only)
307 | TWAP | [Smart, NetPrice] | Optimally-routed order for trading over a period of time at a specified limit price (taker-only)

## Routing Types
The routing type defines how SFOX prioritizes different sources of liquidity when executing your order. SFOX always attempts to execute your order at the best available price.

Routing Type | Description
----------------- | -----------
Smart | Routes orders to the best venues for execution based on their quoted prices. 
NetPrice | Routes orders to the best venues for execution by considering the fees charged by the trading venues along with the offered prices. For more details, see [Net Price Routing](https://www.sfox.com/routing.html).