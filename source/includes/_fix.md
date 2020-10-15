# FIX API

Field | Value | Description
----- | ----- | -----------
HeartBtInt | <=30 | Heart beat interval
BeginString | FIX.4.4 | Only FIX 4.4 is supported
SenderCompID | Anything | You can provide your own sender comp id and have any number of FIX sessions
TargetCompID | SFOX |

## Endpoints

Environment | Value | Description
----------  | ----- | -----------
Production  | fix.sfox.com:5001 | SSL Required
Staging | fix.staging.sfox.com:5001 | SSL Required

## Supported Tags

### Logon - A

Tag | Name | Required | Description
--- | ---- | -------- | -----------
554 | Password | Y | Your API Key (generate one [here](https://trade.sfox.com/account/api))

### NewOrderSingle - D

Tag | Name | Required | Default | Description
--- | ---- | -------- | ------- | -----------
11 | ClOrdID | Y | | Client provided order ID, must be unique per-account
55 | Symbol | Y | | Trading pair (see: [List Asset Pairs](#list-asset-pairs))
54 | Side | Y | | 1 = Buy, 2 = Sell
40 | OrdType | Y | | 1 = Market, 2 = Limit, 3 = Stop, or any of our [Algoritm IDs](#algorithms)
44 | Price | Y (except market orders) | | Limit Price
38 | OrderQty | Y | | For limit orders, this is the quantity to trade in the base currency. For Market Sell orders, this is the amount in the base currency.
152 | CashOrderQty | Y (OrdType = 1 AND Side = 1 or OrdType = 3 (stop) AND Side = 1 (buy)) | |  For market buy orders, this is the amount to spend in the quote currency
59 | TimeInForce | N | 1 (GTC) | The lifetime of the order, immediate or cancel (3) and good till cancel (1)
21 | HandlInst (semi-custom) | N | 2 (NetPrice) |  RoutingType: 1 = Rest API default (empty), 2 = NetPrice, 3 = Enterprise

Below are the custom fields that are algorithm specific:

Tag | Name | Algorithm | Required | Default | Description
--- | ---- | --------  | -------- | ------- | -----------
20000 | StopAmount | Trailing Stop (308) | N |  | The fixed amount to trail the market price by
20001 | StopPercent | Trailing Stop (308) | N | | The percentage to trail the market price by (given as a decimal: 10% = 0.1)
20010 | Interval | TWAP (307) | Y | | The frequency at which TWAP trades are executed (in seconds)
20011 | TotalTime | TWAP (307) | Y | | The maximimum time a TWAP order will stay active (in seconds). Must be >= 15 minutes (900 seconds) and the interval (tag 20010)
20020 | RoutingOption | Gorilla (301), Hare (303) | Y | | How SFOX will trade your order, `BestPrice` or `Fast`

### OrderStatusRequest - H

Tag | Name | Required | Description
--- | ---- | -------- | -----------
11 | ClOrdID | Y | Original ClOrdID when creating the order
790 | OrdStatusReqID | N | Optionally provided value that will be echoed in the response

### OrderCancelRequest - F

Tag | Name | Required | Description
--- | ---- | -------- | -----------
41 | OrigClOrdID | Y | Original ClOrdID provided when creating the order

### ExecutionReport - 8

Tag | Name | Description
--- | ---- | -----------
37 | OrderID | SFOX Assigned Order ID
11 | ClOrdID | Client provided order ID
55 | Symbol | Trading pair
54 | Side | 1 = Buy, 2 = Sell
40 | OrdType | 1 = Market, 2 = Limit
44 | Price | Client provided limit price, only if OrdType = 2
150 | ExecType | Execution type: 0 = New, 3 = Done, 4 = Canceled, 8 = Rejected, F = Fill/Parial, I = Order Status Request
39 | OrdStatus | Current status of the order: 0 = New, 1 = Partially Filled, 2 = Filled, 3 = Done, 4 = Canceled
151 | LeavesQty | Amount remaining of the order
14 | CumQty | Amount filled so far of the order
799 | AvgPx | VWAP

### OrderCancelReject - 9

Tag | Name | Description
--- | ---- | -----------
37 | OrderID | SFOX Order ID, unless the order is unknown (CxlRejReason = Unknown Order)
11 | ClOrdID | Client provided order ID of the cancel request
41 | OrigClOrdID | Client provided order ID of the original order (echoed back from the request)
39 | OrdStatus | Existing status of the order that could not be canceled
