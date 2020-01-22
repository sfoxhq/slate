# REST Endpoints

Endpoint | Description
--------- | -----------
Production | https://api.sfox.com
Sandbox | [Contact support](mailto:support@sfox.com)

# Authentication

> To authorize, use this code:

```shell
# With shell, you can just pass the correct header with each request
$ curl -u "<api token>:" api_endpoint_here
```

```python
import requests
auth = requests.auth.HTTPBasicAuth("<api_token>", "")
requests.get("api_endpoint_here", auth=auth)
```

> Make sure to replace <api_key> with your API key, and don't forget the colon in the shell example

SFOX uses API keys to grant access. You can create a new SFOX API key at our [developer portal](https://trade.sfox.com/account/api).

The API key should be included in all API requests to the server in the `Authorization` header that looks like the following:

`Authorization: Bearer <api_key>`

<aside class="notice">
    You must replace `api_key` with your personal API key.
</aside>
