# Drop-Down — Portal Policy Template Bundles

This folder contains **drop-down selection field** policy template examples for the Layer7 API Developer Portal. Each bundle demonstrates the `l7.enum.<name>` / `l7.enum.<name>.<value>` argument-naming convention that turns a free-form template input into a drop-down menu shown to API publishers in the Portal when the template is applied to an API. See the **Drop-Down Selection Fields** section of the [`Layer7 API Developer Portal Policy Templates Guide.md`](../Layer7%20API%20Developer%20Portal%20Policy%20Templates%20Guide.md) for the underlying capability.

## Bundles in this folder

### `DropDownExample-1.0.0.json`
Installs the **`DropDownExample-1.0`** template. Demonstrates how to expose a Portal drop-down selection field on an encapsulated assertion. The encass defines a primary input argument named `l7.enum.example` — the field the publisher actually fills in — alongside two option inputs `l7.enum.example.A` and `l7.enum.example.B`. Following the `l7.enum.<name>.<value>` naming convention, those two option inputs are interpreted by the Portal as the selectable values, so when the template is applied to an API the publisher is presented with a drop-down menu containing `A` and `B` rather than a free-form text field; the chosen value is available inside the fragment at runtime as `${l7.enum.example}`. The order in which the option arguments are listed on the encapsulated assertion (via `ordinal`) determines the order the publisher sees in the drop-down, and adding a `*` to the `guiLabel` of the primary argument marks the selection as mandatory.

The fragment body itself is intentionally minimal — it exists only so the encapsulated assertion has a backing policy. Use this bundle as a starting point for any template that needs a publisher-selected enumerated input: replace the body with your own policy logic that branches on `${l7.enum.example}` to perform routing decisions, header rewrites, environment-specific handling, etc.

**Arguments:** `l7.enum.example` (the primary drop-down input — the selected value is available at runtime as `${l7.enum.example}`), `l7.enum.example.A` (first selectable option, value `A`), `l7.enum.example.B` (second selectable option, value `B`).
**Exported context variables:** _none_.

## Adding additional drop-down options

To add a third option `C`, copy the existing `l7.enum.example.B` argument, rename it to `l7.enum.example.C`, set its `ordinal` to the next sequential value, and update the `guiLabel` to whatever text you want the publisher to see in the Portal. No further Portal-side configuration is required — the new option will appear in the drop-down automatically the next time the template is deployed.

To use this bundle as a template for an entirely new drop-down (for example, an environment selector named `l7.enum.deployment` with options `QA` and `PRODUCTION`), rename the argument set accordingly and reference `${l7.enum.deployment}` from your fragment.

## Conventions

Bundles in this folder follow the same conventions as the other Portal Templates in this repository:

- Distributed as a `*-<version>.json` policy bundle (schema `11.2.1`, `defaultAction: NEW_OR_UPDATE`).
- Installs a policy fragment under `/Portal Templates/` and an encapsulated assertion in the Policy Manager assertion palette.
- Drop-down menus are configured purely through the `l7.enum.<name>` / `l7.enum.<name>.<value>` argument naming convention on the encapsulated assertion — no Portal-side configuration is required.

Contributions are welcome — drop a new `*-<version>.json` bundle into this folder and add a corresponding entry in the **Bundles in this folder** section above.
