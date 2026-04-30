# Routing — Portal Policy Template Bundles

This folder is reserved for **routing-focused** policy template bundles for the Layer7 API Portal. Bundles published here are intended to demonstrate Portal-aware routing patterns such as:

- Selecting a backend service URL based on the Portal API's environment, account plan, or custom metadata.
- Rewriting request headers, paths, or query parameters before forwarding to the upstream service.
- Applying conditional or weighted routing across multiple backends.
- Adding Portal analytics or correlation context to outbound requests.

## Status

This folder is currently **empty** — no routing bundles have been published yet.

When bundles are added, each will follow the same conventions as the other Portal Templates in this repository:

- Distributed as a `*-<version>.json` policy bundle (schema `11.2.1`, `defaultAction: NEW_OR_UPDATE`).
- Installs a policy fragment under `/Portal Templates/` and an encapsulated assertion under the *internalAssertions* palette folder.
- Accepts `portal.managed.service.apiId` as its primary argument so it can be composed with the authentication bundles in [`../Authentication/`](../Authentication).
- Documented in this README with a short summary of the assertion's behaviour, inputs, outputs, and any Portal context variables it consumes or sets.

Contributions are welcome — drop a new `*.json` bundle into this folder and add a corresponding entry below.
