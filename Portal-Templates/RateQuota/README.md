# Rate & Quota — Portal Policy Template Bundles

This folder contains **rate-limit and quota** policy template bundles for the Layer7 API Developer Portal. The Portal Templates Guide places this kind of template in the **Rate and Quota Enforcement** category (see the [Layer7 API Developer Portal Policy Templates Guide](../Layer7%20API%20Developer%20Portal%20Policy%20Templates%20Guide.md)).

## Background — Organization Rate Limit and Quota

> **Organization Rate Limit and Quota** was formerly known as **Account Plan**. The two terms refer to the same Portal capability: enforcing rate-limit and quota policy at the **per-Organization** scope (rather than per-API or per-API-Key).

Note that **the system-provided "Standard" Rate-Quota policy templates that ship with the Portal currently do NOT enforce the per-Organization (Account Plan) limits** — they only enforce per-API limits. Until the system templates are updated to cover the per-Organization scope, this additional bundle must be applied as a Portal policy template whenever you need rate-and-quota enforcement at the per-Organization level. The legacy `Standard Policy Template - API Key` did include this enforcement inline (its "Step 3 — Enforce Account Plan restriction" block); the bundle here is that block lifted out into a self-contained, composable template.

## Bundles in this folder

### `OrgLevelRLQ-1.0.0.json`
Installs the **`OrgLevelRLQ-1.0`** template. Enforces the Organization-level (Account Plan) rate-limit and quota for a Portal-managed API. The fragment is intended to run **after** an API-key-lookup template such as one of the bundles in [`../Authentication/`](../Authentication) — it assumes the API key has already been looked up and that the resulting `apiKeyRecord.*` variables are wired in as encass inputs. Internally it:

1. Initialises the working variables consumed by the system-managed Account Plans logic — `apiKey` ← `${apiKeyRecord.key}`, `apiPlan` ← `${apiKeyRecord.plan}`, `accountPlanMappingId` ← `${apiKeyRecord.accountPlanMappingId}`, plus `apiAuthz=true`, `apiAuthzDetails=""`, `errorMsg=""`.
2. **Includes** the auto-generated **Account Plans Fragment** (Layer7 system policy GUID `f8a5669d-831e-4417-9225-f52527f90323`). This fragment is created on the gateway automatically when a gateway is enrolled with the Portal and Account Plans (Organizations) are configured; it is *not* part of this bundle and the bundle has no way to install it.
3. Inspects `${apiAuthz}` after the include. If it is still `"true"` the rate/quota check passed; the fragment populates `portal.analytics.organization.uuid`, `portal.analytics.organization.name`, and `portal.analytics.apikey` and exports them so a parent template can read them. If `${apiAuthz}` is anything other than `"true"`, the rate/quota was exceeded — the fragment builds a `503` response with body `Rate limit and/or quota exceeded. See reason below.\r\n\r\nReason: ${apiAuthzDetails}`, sets `portal.analytics.response.code=503`, populates the same analytics variables, exports them, and then short-circuits the request with a *Customize Error Response* + *FalseAssertion*.

**Prerequisites**

- The gateway is enrolled with the Layer7 API Developer Portal.
- Account Plans (a.k.a. Organization Rate Limit and Quota) have been configured in the Portal so the auto-generated Account Plans Fragment exists on the gateway.
- An API-key-lookup template (e.g. `APIKeyValidation-1.0`, `APIKeySecretValidation-1.0`, `mTLSValidation-1.0`) has run earlier in the parent template and exposes the `apiKeyRecord.*` outputs documented below.

**Arguments (inputs):** `apiKeyRecord.id`, `apiKeyRecord.key`, `apiKeyRecord.plan`, `apiKeyRecord.accountPlanMappingId`, `apiKeyRecord.accountPlanMappingName` — all `STRING`, all hidden from the publisher (`guiPrompt: false`). The names match the encass-results that the bundles in `../Authentication/` already publish, so the parent template can wire them in directly.

**Exported context variables (outputs):** `apiAuthz`, `apiAuthzDetails`, `errorMsg`, `portal.analytics.apikey`, `portal.analytics.organization.name`, `portal.analytics.organization.uuid`, `portal.analytics.response.code`.

## Where this template fits in a Portal policy chain

The intended order in a Portal policy template chain (when **not** using the Standard system templates) is:

1. **Authentication** — one of `../Authentication/*` runs first and looks up the API key, exposing `apiKeyRecord.*`.
2. **`OrgLevelRLQ-1.0`** *(this bundle)* — enforces per-Organization rate/quota. Short-circuits the request with `503` if exceeded.
3. **Per-API rate/quota** — the system-provided Standard Rate-Quota templates can run here for the per-API scope.
4. **Other templates** — e.g. request validation (`../RequestValidation/`), routing (`../Routing/`).

## Future direction

When the system-provided Standard Rate-Quota templates are updated to include per-Organization enforcement natively, this bundle will become redundant for new deployments. Until then, treat it as the canonical way to bring per-Organization Rate Limit and Quota into a non-Standard template chain.

## Conventions

Bundles in this folder follow the same conventions as the other Portal Templates in this repository:

- Distributed as a `*-<version>.json` policy bundle (schema `11.2.1`, `defaultAction: NEW_OR_UPDATE`).
- Installs a policy fragment under `/Portal Templates/` and an encapsulated assertion in the Policy Manager assertion palette (`internalAssertions` palette folder, matching the legacy API Portal integration fragments).
- Designed to be composed with the bundles under [`../Authentication/`](../Authentication) so that authentication runs first, this bundle runs second to enforce per-Organization limits, and per-API enforcement / routing follow.

Contributions are welcome — drop a new `*-<version>.json` bundle into this folder and add a corresponding entry in the **Bundles in this folder** section above.
