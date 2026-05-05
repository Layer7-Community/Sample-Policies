# Secret Fields — Portal Policy Template Bundles

This folder contains **secure secret field** policy template examples for the Layer7 API Developer Portal. Each bundle demonstrates the `l7.secure.<name>` argument-naming convention that turns a free-form template input into a masked input field shown to API publishers in the Portal: the value the publisher types is encrypted, stored as a Gateway *stored password*, and never appears in logs, exported bundles, or audit records. See the **Secure Secret Fields** section of the [`Layer7 API Developer Portal Policy Templates Guide.md`](../Layer7%20API%20Developer%20Portal%20Policy%20Templates%20Guide.md) for the underlying capability.

## Bundles in this folder

### `SecretFieldsExample-1.0.0.json`
Installs the **`SecretFieldsExample-1.0`** template. Demonstrates how to expose two Portal secure (masked) input fields — a username and a password — on an encapsulated assertion, and then read the deciphered values at runtime so they can be used by the surrounding policy. The encass defines two arguments named `l7.secure.username` and `l7.secure.password`, both with `type: STRING` and `guiPrompt: true`. Following the `l7.secure.<name>` convention, the Portal recognises them as secret fields and (a) renders them as masked inputs in the publisher's UI, (b) stores their values encrypted as Gateway stored-password entries on deployment, and (c) makes them available inside the fragment as the context variables `${l7.secure.username}` and `${l7.secure.password}`. Both `guiLabel`s are suffixed with `*` so the Portal marks the field as mandatory.

The fragment body shows a minimal example of how to read the secure values into your own context variables — two **Set Variable** assertions assign `${l7.secure.username}` to a new local variable named `serviceUsername` and `${l7.secure.password}` to `servicePassword`. From that point on, downstream assertions in any policy that consumes this fragment can reference `${serviceUsername}` and `${servicePassword}` exactly like any other context variable. Replace those Set Variable assertions (and add to them) with whatever your own template needs to do — for example, attach the credentials to an outbound HTTP routing assertion's *Authentication* tab, or pass them to a downstream encapsulated assertion that calls a backend service.

**Arguments:** `l7.secure.username` (masked, mandatory — referenced as `${l7.secure.username}`), `l7.secure.password` (masked, mandatory — referenced as `${l7.secure.password}`).
**Exported context variables:** _none_. The new local variables (`serviceUsername`, `servicePassword`) are intentionally **not** added to the encapsulated assertion's `encassResults` and **not** exported via *Export Variables from Fragment* — see the security note below.

## Security notes

- **Decrypted values are scoped to this fragment.** Because `serviceUsername` and `servicePassword` are not declared as encass results, they live only inside this fragment's local scope. The deciphered password never leaves the fragment, which limits the blast radius if a parent template is later modified to do something unsafe (e.g. an audit-detail or trace assertion that logs all variables).
- **Avoid logging the deciphered values.** Do not place an *Audit Detail* assertion that interpolates `${servicePassword}` (or `${l7.secure.password}`) into its message. Layer7 has built-in protections that replace `l7.secure.*` references with `********` in audits, but once you copy the value into a non-`l7.secure.*` variable that protection no longer applies.
- **Prefer using the secure variable directly where possible.** If you only need the credentials for, say, an HTTP routing assertion's *Authentication* tab, reference `${l7.secure.username}` / `${l7.secure.password}` straight from that assertion rather than copying them into intermediate variables. The intermediate-variable pattern shown by this bundle is provided as the requested example, not as a recommended default.

## Conventions

Bundles in this folder follow the same conventions as the other Portal Templates in this repository:

- Distributed as a `*-<version>.json` policy bundle (schema `11.2.1`, `defaultAction: NEW_OR_UPDATE`).
- Installs a policy fragment under `/Portal Templates/` and an encapsulated assertion in the Policy Manager assertion palette.
- Secret fields are configured purely through the `l7.secure.<name>` argument-naming convention on the encapsulated assertion — no Portal-side configuration is required.

Contributions are welcome — drop a new `*-<version>.json` bundle into this folder and add a corresponding entry in the **Bundles in this folder** section above.
