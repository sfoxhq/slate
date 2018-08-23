# Authentication

> To authorize, use this code:

```shell
# With shell, you can just pass the correct header with each request
curl "api_endpoint_here" \
  -u "<api token>:"
```

> Make sure to replace <api_key> with your API key, and don't forget the colon.

SFOX uses API keys to grant access. You can create a new SFOX API key at our [developer portal](https://trade.sfox.com/account/api).

The API key should be included in all API requests to the server in a header that looks like the following:

`Authorization: Bearer <api_key>`

<aside class="notice">
You must replace `api_key` with your personal API key.
</aside>

