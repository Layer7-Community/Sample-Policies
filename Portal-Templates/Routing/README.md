# Routing — Portal Policy Template Bundles

This folder contains **routing-focused** policy template bundles for the Layer7 API Portal. Each bundle installs an encapsulated assertion plus its backing policy fragment (under `/Portal Templates/`) and demonstrates a Portal-aware routing pattern such as:

- Forwarding the inbound request to a backend service URL.
- Rewriting request headers, paths, or query parameters before routing.
- Applying conditional or weighted routing across multiple backends.
- Adding Portal analytics or correlation context to the outbound request.

## Bundles in this folder

### `RouteRequest-1.0.0.json`
Installs the **`RouteRequest-1.0`** template. Performs the **Route via HTTP** assertion to forward the inbound request to the backend identified by its `apiLocation` argument, after stripping the API's published `serviceUrl` path prefix from `${request.http.uri}` so only the API-relative path (plus the original `${request.url.query}`) is forwarded upstream. On a successful backend call the backend HTTP status is captured in `portal.analytics.response.code`; on a routing failure the request is short-circuited with a **`502`** `"Unable to route to API."` response and the same variable is still populated so analytics remain consistent. The fragment additionally exports `override_template_routing` via the **Export Variables from Fragment** assertion, allowing a parent Portal template to detect that routing was handled here and skip its own default routing.

**Arguments:** `apiLocation` (fully-qualified backend base URL — e.g. `https://api.internal.example.com`), `serviceUrl` (the Portal API's published `serviceUrl` path prefix to strip from the request URI).
**Exported context variables:** `override_template_routing`, `portal.analytics.response.code`.

## Conventions

Bundles in this folder follow the same conventions as the other Portal Templates in this repository:

- Distributed as a `*-<version>.json` policy bundle (schema `11.2.1`, `defaultAction: NEW_OR_UPDATE`).
- Installs a policy fragment under `/Portal Templates/` and an encapsulated assertion under the *customAssertions* palette folder.
- Designed to be composed with the bundles under [`../Authentication/`](../Authentication), so that authentication runs first in the parent template and routing runs last.

Contributions are welcome — drop a new `*-<version>.json` bundle into this folder and add a corresponding entry in the **Bundles in this folder** section above.
