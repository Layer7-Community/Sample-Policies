# JWT Parsing Demo
A simple policy to demonstrate how to parse an unsigned JWT

# Flow
A JWT is hard coded in the policy which is then decoded using the 'Decode Json Web Token' assertion, after which the header and payload are cast to message type context variables and the values extracted using JSON path, which are returned in a template response to the requester.

# Deployment
- Publish a Web API service via the Policy Manager
- Import the 'JWT Parsing Demo.xml' file from this repository
- Access the service with a browser or curl to see the parsing result
