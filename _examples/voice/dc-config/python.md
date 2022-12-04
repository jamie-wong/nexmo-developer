---
title: Python
language: python
---

```python
from vonage import Client

client = Client(key='YOUR_API_KEY', secret='YOUR_API_SECRET')
client.host('rest-ap-3.vonage.com')
client.api_host('api-ap-3.vonage.com')
```