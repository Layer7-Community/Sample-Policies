# Layer7 API Portal — Policy Template Bundles

This folder contains a collection of example **policy template bundles** that can be imported into the Layer7 API Gateway and used with the **Layer7 API Developer Portal**. Each bundle ships a ready-to-use encapsulated assertion (and its backing policy fragment) that implements a common Portal-aware concern — authentication, routing, traffic management, etc. — so that API publishers can drop the assertion into their managed-service policies without re-inventing the logic.

> **For more information on working with policy templates**, refer to the [`Layer7 API Developer Portal Policy Templates Guide.md`](./Layer7%20API%20Developer%20Portal%20Policy%20Templates%20Guide.md) in this folder. That guide is the authoritative reference for how Portal policy templates are designed, built, packaged, deployed, and referenced from a managed-service policy, and should be consulted before authoring or modifying any of the bundles below.

## How to use these bundles

1. Import the desired `*.json` bundle into your Layer7 API Gateway (Policy Manager → *Manage Policy Bundles*, or via the Restman/GMU bundle import tooling). All bundles target schema `11.2.1` and use a `defaultAction` of `NEW_OR_UPDATE`.
2. Each bundle installs:
   - A **policy fragment** under `/Portal Templates/`.
   - An **encapsulated assertion** (palette folder: *internalAssertions*) that wraps the fragment and exposes it to Portal-managed services.
3. Reference the encapsulated assertion from your managed API policy, supplying the `portal.managed.service.apiId` argument (typically `${portal.managed.service.apiId}`).
4. On success, the assertion exports the standard `apiKeyRecord.*` and `portal.analytics.*` context variables that downstream Portal policies expect (rate-limiting, quota, analytics, etc.). On failure, it returns an HTTP error and short message.

## Folder summary

| Folder | Description |
| --- | --- |
| [`Authentication/`](./Authentication) | Encapsulated assertions that authenticate the caller against a Portal-managed API. Includes API key (header/query), API key + secret (HTTP Basic, with hashed-secret support), OAuth 2.0 access-token, and mutual-TLS (client certificate) variants. |
| [`Routing/`](./Routing) | Reserved for example bundles that demonstrate Portal-aware routing patterns (e.g. backend selection, header rewriting, environment-based routing). Currently empty — bundles will be added here as they are published. |

## Conventions used by every bundle

All bundles in this repository follow the same conventions so they can be composed with each other and with stock Portal policy:

- **Single argument:** `portal.managed.service.apiId` (`STRING`) — the UUID of the managed Portal API the request is being authorized against.
- **Standard results exported on success:** `apiKeyRecord.id`, `apiKeyRecord.key`, `apiKeyRecord.status`, `apiKeyRecord.plan`, `apiKeyRecord.accountPlanMappingId`, `apiKeyRecord.accountPlanMappingName`, plus an `errorMsg` string that is empty on success.
- **Portal analytics variables** are always populated so that the Portal's analytics pipeline records the call correctly: `portal.analytics.authType`, `portal.analytics.api.uuid`, `portal.analytics.apikey`, `portal.analytics.application.uuid`, `portal.analytics.application.name`, `portal.analytics.organization.uuid`, `portal.analytics.organization.name`, and `portal.analytics.response.code`.
- **Failure behaviour:** when validation fails, the fragment uses *Customize Error Response* to return the status code in `portal.analytics.response.code` (typically `401`, or `403` for transport-level failures) with `errorMsg` as the body, and then falls through with a `FalseAssertion` so the calling policy short-circuits.

## More information

For comprehensive guidance on the Portal policy template framework — including template structure, lifecycle, version compatibility, and best practices for authoring your own templates — refer to the [`Layer7 API Developer Portal Policy Templates Guide.md`](./Layer7%20API%20Developer%20Portal%20Policy%20Templates%20Guide.md) located in this folder.

## License & support

These bundles are provided as community samples. Review and adapt the policy logic to match your organization's security, compliance, and operational requirements before deploying to production.
