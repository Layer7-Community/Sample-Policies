# Authentication — Portal Policy Template Bundles

This folder contains policy template bundles that **authenticate an inbound request against a Layer7 API Portal–managed API**. Each bundle installs an encapsulated assertion plus its backing policy fragment (under `/Portal Templates/`).

## Bundles in this folder

### `APIKeyValidation-1.0.0.json`
Installs the **`APIKeyValidation-1.0`** template. Validates that an incoming **API key** — supplied either in the `apikey` HTTP header or in the `apikey` query parameter — exists in the Portal, is bound to the managed API identified by `portal.managed.service.apiId`, and has a status of `active`. Returns **`401`** with `"API key is missing from request"` or `"API key not found or invalid"` on failure. `portal.analytics.authType` is set to `API_KEY`. **NOTE** This template does not provide true authentication and should only be used in cases where authentication is not required and the API Key is only used for tracking purposes.

### `APIKeySecretValidation-1.0.0.json`
Installs the **`APIKeySecretValidation1.0`** template. Validates an **API key + secret** pair supplied as **HTTP Basic credentials** (username = API key, password = secret). After confirming the key is found, scoped to this API, and `active`, it compares the request's secret against the value stored on the Portal API key record:

- If the API key record has no `hashingMetadata`, the plaintext secret is compared directly.
- If hashing metadata is present, the bundle calls **`Portal Read Hashed Metadata`** and **`Portal Create Hash`** to derive the expected hash (using the configured algorithm and salt) and compares against `apiKeyRecord.secret`.

Returns **`401`** with `"API key or secret missing from HTTP Basic credentials"`, `"API key not found or invalid"`, or `"Invalid API key secret"` on failure. `portal.analytics.authType` is set to `API_KEY`.

### `OAuth2Validation-1.0.0.json`
Installs the **`OAuth2Validation1.0`** template. Validates a Bearer **OAuth 2.0 access token** by invoking the Portal's stock **`Portal Require OAuth 2.0 Token`** verifier (no scope filtering, no one-time-token mode, no cache override). On success, the OAuth `client_id` (`${session.client_id}`) is used as the API key for the standard Portal lookup, ensuring the OAuth client is also a registered Portal application authorized for `portal.managed.service.apiId` and is `active`. Returns **`401`** with `"OAuth 2.0 token missing or invalid"` or `"OAuth client (API key) is not authorized for this API"` on failure. `portal.analytics.authType` is set to `OAUTH_2`.

### `mTLSValidation-1.0.0.json`
Installs the **`mTLSValidation1.0`** template. Layered authentication that combines API key validation with **mutual-TLS client-certificate pinning**. The fragment performs four steps:

1. **Require SSL/TLS transport** — if the request did not arrive over TLS the assertion returns **`403`** with `"SSL/TLS transport is required"`.
2. **Pick the API key** from the `apikey` header (preferred) or `apikey` query parameter.
3. **Look up the API key** via `Portal Look Up API Key (Generic)` and confirm it is found, scoped to this API, and `active`.
4. **Require a client certificate** (`SslAssertion` with `RequireClientAuthentication=true`) and verify it matches a certificate published in the API key's `CustomMetaData` **JWKS**. The fragment parses `apiKeyRecord.xml` → `CustomMetaData` → `jwks.keys`, base64-decodes each entry's `x5c[0]` into a certificate, and compares its SHA-256 thumbprint against `${request.ssl.clientCertificate.thumbprintSHA256}`. A match sets `certificateValidated=true`; otherwise the request is rejected with **`401`** `"Invalid client certificate"`.

`portal.analytics.authType` is set to `API_KEY`. This bundle is intended for APIs that need both an application identity (the API key) and cryptographic proof-of-possession of a registered client certificate.

## Picking the right bundle

| Use case | Bundle |
| --- | --- |
| Simple application identity via shared API key | `APIKeyValidation-1.0.0.json` |
| Stronger application identity using API key + secret (Basic auth, hashing-aware) | `APIKeySecretValidation-1.0.0.json` |
| User/application identity via standard OAuth 2.0 access tokens | `OAuth2Validation-1.0.0.json` |
| API key plus pinned client certificate (mTLS) | `mTLSValidation-1.0.0.json` |
