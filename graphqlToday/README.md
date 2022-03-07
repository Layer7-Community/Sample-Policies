# GraphQL Today Patterns
This sample policy illustrates how to proxy GraphQL in the gateway today. These patterns are valid with out-of-box gateway functionality and do not require the new specialized GraphQL assertions.

Note that these patterns are GraphQL specific, but many other pre-existing patterns are also applicable to GraphQL APIs. This includes the authentication/authorization or GraphQL requests, the rate-limiting of GraphQL requests, etc. 

## Import Sample Policy
- Create a new Web API, specify a name such as "GraphQL Today" and a Gateway URL such as "/graphtoday"
- From toolbar Import Policy, select the xml policy
- Plug in your own graphql target (in generic example set to "http://host.docker.internal:4000/" at line 19).

## Understanding the GraphQL Patterns
### Ignore Introspection
line 9

Introspection calls happen between client applications such as GraphiQL and GraphQL endpoints. Especially in a development environment, you might want to treat these instrospection calls separately to optimize DX (developer experience). In this example, we simply ignore these introspection calls.

### Isolating the actual graph query
line 13

GraphQL queries are sent over HTTP wrapped inside a JSON HTTP payload. You can isolate the query portion of the incoming request using a simple JSON Path expression.

### Counting (and limiting) query nesting
line 16

To protect a GraphQL backend, you might want to limit the query nesting. GraphQL queries follow their own non-JSON syntax which makes parsing them tricky. This is why we are adding GraphQL assertions in the gateway. You can, however, traverse GraphQL queries in policy in javascript. This example shows counting the query nesting.

### Response validation and transformation
line 22

GraphQL responses are structured in JSON format. You can use any existing Layer7 gateway assertion for JSON with such responses. In this example, we look for the presence of a stack trace information embedded in a json response containing an error and we are removing this stack trace before returning it to the client.

