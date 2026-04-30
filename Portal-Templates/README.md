# Layer7 API Portal — Policy Template Bundles

This folder contains a collection of example **policy template bundles** that can be imported into the Layer7 API Gateway for viewing and modification to meet your needs. They may be used with the **Layer7 API Developer Portal** by directly importing them via the Manage->Gateway Bundles menu (NOTE: these are examples and must be reviewed prior to any production use). Each bundle ships a ready-to-use encapsulated assertion (and its backing policy fragment) that implements a common Portal-aware concern — authentication, routing, traffic management, etc. — so that API publishers can drop the template into their APIs without re-inventing the logic.

> **For more information on working with policy templates**, refer to the [`Layer7 API Developer Portal Policy Templates Guide.md`](./Layer7%20API%20Developer%20Portal%20Policy%20Templates%20Guide.md) in this folder. That guide is the authoritative reference for how Portal policy templates are designed, built, packaged, deployed, and referenced from an API, and should be consulted before authoring or modifying any of the bundles below.

## How to use these bundles

1. Import the desired `*.json` bundle into your Layer7 API Gateway (Web Based Policy Manager → *Import Graphman Bundles*, or via the Graphman Client).
2. Each bundle installs:
   - A **policy fragment** under `/Portal Templates/`.
   - An **encapsulated assertion** that wraps the fragment and exposes it to Portal-managed services.
3. View and modify the policy as needed to meet your needs.
4. Export the final bundle that you wish to use so that it may be imported into the API Portal.

## Folder summary

| Folder | Description |
| --- | --- |
| [`Authentication/`](./Authentication) | Template bunldes that authenticate the caller against a Portal-managed API. Includes API key (header/query), API key + secret (HTTP Basic, with hashed-secret support), OAuth 2.0 access-token, and mutual-TLS (client certificate) variants. |
| [`Routing/`](./Routing) | Template bundles that demonstrate Portal-aware routing patterns (e.g. backend selection, header rewriting, environment-based routing). Currently empty — bundles will be added here as they are published. |


## More information

For comprehensive guidance on the Portal policy template framework — including template structure, lifecycle, version compatibility, and best practices for authoring your own templates — refer to the [`Layer7 API Developer Portal Policy Templates Guide.md`](./Layer7%20API%20Developer%20Portal%20Policy%20Templates%20Guide.md) located in this folder.

## License & support

These bundles are provided as community samples. Review and adapt the policy logic to match your organization's security, compliance, and operational requirements before deploying to production.
