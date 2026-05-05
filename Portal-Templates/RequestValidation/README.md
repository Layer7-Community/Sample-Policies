# Request Validation — Portal Policy Template Bundles

This folder contains **request-validation** policy template bundles for the Layer7 API Developer Portal. Each bundle is intended to demonstrate Portal-aware patterns for validating an incoming API request before it reaches the backend — e.g. validating it against the API's published OpenAPI specification, against a JSON Schema, against an XML Schema, or against custom rules. The Portal Templates Guide places this kind of template in the **Message Validation** category, alongside `Validate JSON Schema` and `Validate XML Schema` (see the [Layer7 API Developer Portal Policy Templates Guide](../Layer7%20API%20Developer%20Portal%20Policy%20Templates%20Guide.md) for category guidance).

## Bundles in this folder

### `ValidateOpenAPISample-1.0.0.json`
Installs the **`ValidateOpenAPISample-1.0`** template. Validates an incoming request against the OpenAPI 3.x specification that the Portal publishes for each API in the service property `service.property.internal.apiSpec`. The bundle wraps a single `Validate Against OpenAPI Document` assertion (`<L7p:OpenApi>`) inside a four-way `OneOrMore` switch that is driven by a Portal **drop-down** input argument (`l7.enum.option`) called *Validation Profile*. Each branch sets every option on the underlying assertion explicitly so that the assertion's full option surface is visible at a glance — this makes the bundle a useful starting point for any team that wants to drop OpenAPI validation into their own template and tune it from there.

**Validation profiles offered to the publisher**

| Profile | `ValidatePath` | `ValidateMethod` | `ValidateHeaders` | `ValidateQueryParameters` | `ValidateBody` | `RequireSecurityCredentials` | `StrictValidation` |
| --- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| `path` | true | false | false | false | false | false | false |
| `path_and_method` | true | true | false | false | false | false | false |
| `request` | true | true | true | true | true | true | false |
| `request_strict` | true | true | true | true | true | true | true |

`UseOpenApiDocAsUrl` is set to `false` in every branch (the spec comes from a context variable, not a URL) and `Prefix` is set to the assertion default `openapi`, so the result variables are exposed as `${openapi.path}`, `${openapi.expandedPath}`, `${openapi.servers}`, `${openapi.errors}`, and `${openapi.errorDetails}`.

If none of the profiles match, **or** the selected profile's `Validate Against OpenAPI Document` assertion fails, the fallback branch logs the validation failure via *Audit Detail* and returns a `500 application/json` body of the form:

```json
{
  "error": {
    "code": 500,
    "message": "OpenAPI spec validation failed. Profile: <profile>"
  }
}
```

**Arguments:** `l7.enum.option` (the *Validation Profile* drop-down, mandatory — referenced as `${l7.enum.option}`), and four option arguments — `l7.enum.option.path`, `l7.enum.option.path_and_method`, `l7.enum.option.request`, `l7.enum.option.request_strict` — that populate the drop-down menu using the `l7.enum.<name>` / `l7.enum.<name>.<value>` convention (see `../DropDown/README.md` for the convention itself).
**Exported context variables:** `openapi.errors`, `openapi.expandedPath`, `openapi.path`, `openapi.servers` (declared as encass results so a parent template can read them).

## All `Validate Against OpenAPI Document` options reference

These are every option supported by the `<L7p:OpenApi>` assertion in Gateway 11.2; each one is set explicitly in every branch of `ValidateOpenAPISample-1.0` so they're easy to find and edit:

| Option | Default | Notes |
| --- | :---: | --- |
| `OpenApiDoc` | _required_ | Name of a context variable holding the OpenAPI 3.x spec (or a URL when `UseOpenApiDocAsUrl=true`). For Portal-managed APIs this is `service.property.internal.apiSpec`. |
| `UseOpenApiDocAsUrl` | `false` | When `true`, treats `OpenApiDoc` as a URL to download the spec from (Gateway 10.0 CR4+). |
| `Prefix` | `openapi` | Prefix for output context variables (e.g. `openapi.errors`, `openapi.path`). Configure unique prefixes if you need to run multiple instances of the assertion in the same policy. |
| `ServiceBase` | _current service URI_ | Service URI used to identify the service. Must end with `/*` to be resolvable. |
| `ValidatePath` | `true` | Validate the request URI against a defined operation. **Disabling this disables all other validation options.** |
| `ValidateMethod` | `true` | Check that the request HTTP method is allowed for the resolved path. Only effective when `ValidatePath=true`. |
| `ValidateHeaders` | `false` | Validate request headers against the spec's header parameters. |
| `ValidateQueryParameters` | `false` | Validate query-parameter names and types. |
| `ValidateBody` | `false` | Validate JSON request body against the operation's schema. |
| `RequireSecurityCredentials` | `true` | Verify that the security credentials defined in the spec (API key, OAuth, etc.) are present in the request. **Does not authenticate them** — pair with the bundles in `../Authentication/` for that. Only effective when `ValidateMethod=true`. |
| `StrictValidation` | `false` | Reject undefined query parameters and additional body properties. |

For the full Broadcom doc page, see [Validate Against OpenAPI Document Assertion](https://techdocs.broadcom.com/us/en/ca-enterprise-software/layer7-api-management/api-gateway/11-2/policy-assertions/assertion-palette/message-validation-transformation-assertions/validate-against-openapi-document-assertion.html).

## Extending the bundle

- **Response validation.** This bundle validates incoming requests only. The same `<L7p:OpenApi>` assertion can validate outgoing responses (path + method + status + body + headers) by switching the assertion's *Target Message* to `Response`. If you need response validation, duplicate one of the `request` branches, change its target, and add `<L7p:Target target="RESPONSE"/>` plus a unique `Prefix` (e.g. `openapi.response`) so the result variables don't collide with request-side variables.
- **Composing with other templates.** Because the four `openapi.*` results are declared as encass results and exported via *Export Variables from Fragment*, a parent Portal template can read them and decide what to do — e.g. include them in a logging template, or skip routing if `${openapi.errors}` is non-empty.
- **Adding a new profile.** To add a fifth profile (e.g. `headers_only`), copy the existing `l7.enum.option.path` argument, rename it to `l7.enum.option.headers_only`, set the next `ordinal`, and add a matching `<wsp:All>` branch in the policy that compares `${option}` to `headers_only` and configures the `<L7p:OpenApi>` block accordingly.

## Conventions

Bundles in this folder follow the same conventions as the other Portal Templates in this repository:

- Distributed as a `*-<version>.json` policy bundle (schema `11.2.1`, `defaultAction: NEW_OR_UPDATE`).
- Installs a policy fragment under `/Portal Templates/` and an encapsulated assertion in the Policy Manager assertion palette (`customAssertions` palette folder).
- Surface every option of the underlying assertion explicitly in the policy XML so the bundle doubles as documentation of the assertion's option set.

Contributions are welcome — drop a new `*-<version>.json` bundle into this folder and add a corresponding entry in the **Bundles in this folder** section above.
