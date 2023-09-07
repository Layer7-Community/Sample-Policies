# Sample-Policies
This repository is for more general policy examples that are typically self-contained in a single Layer7 API Gateway policy. You will find various examples of policies that may includes scenarios such as javascript, xml/json transformation, math, regular expressions, encryption/decrryption, etc.

## Here is a list of available sample policies

|Name|Brief Description|
|-----|-----------------|
|[**sample**](./policy)|This is a sample policy containing a single comment as used to provide an example of how policies should be described and stored in this repository.|
|[**Cluster Wide Property Manager**](./Cluster-wide-property-manager)|This uses the REST Manage Gateway assertion to provide a simple web page interface to create, update and delete cluster wide properties|
|[**Conditional Auditing**](./Conditional-Auditing)|Enable auditing for specific services via a cluster-wide property|
|[**Expired Certificate Notifcation Service (email)**](./expired-cert-email-notifier)|This sample policy uses the REST Manage Gateway assertion to provide a simple notification service for any trusted certificates that are on the gateway. The service sends emails for any certificates it finds to have expired.|
|[**Gateway As Password Vault**](./Gateway-As-Password-Vault)|Policy to set up a simple password vault on the Gateway that accesses encrypted passwords stored in the Secure Password Store on the Gateway.|
|[**GraphQL Patterns Today**](./graphqlToday)|Proxying GraphQL API in Layer7 Policy prior to new GraphQL assertions|
|[**JWK Grok**](./JWK-Grok)|JWK-Grok is a set of two API Gateway services to help understand how the JOSE features of the API Gateway work.|
|[**JWT Parsing Demo**](./JWT-Parsing-Demo)|A simple policy to demonstrate how to parse an unsigned JWT|
|[**Log4Shell**](./log4shell)|Simple filter that looks for a pattern which may be indicative of a log4shell exploit.|
|[**Restman Policy**](./Restman-Policy)|A replacement policy for the default Gateway REST Management Service that has better documentation, error handling and inline comments.|
|[**Timestamp Difference Demo**](./Timestamp-Difference-Demo)|Policy to illustrate how to calculate the difference between two timestamps submitted as query parameters. Covers manipulating time/date variables and using XPath for arithmetic.|
|[**Trusted Certificate Viewer**](./trusted-certs-viewer)|This polcy uses the  REST Manage Gateway assertion to provide a simple web page interface to view all the trusted certificates and the expiry date|
|[**MAG Push Notificatioin**](./MAG-PushNotification)|This policy demonstrates how to send a message to FCM by generating an oauth token from Firebase Service account|

## Using the Repository

Each sample policy should be stored in "policy" folder and given a reasonably descriptive name. Most policies will be a single policy. Policies may be grouped into subfolders for examples that are related such as variations on a common them (i.e. encryption, logging, transformation, etc.).

## Feedback
We are certainly happy about any feedback on these tutorials, especially if they helped you in your daily work life! We are also available via the [Layer7 Communities](https://community.broadcom.com/enterprisesoftware/communities/communityhomeblogs?CommunityKey=0f580f5f-30a4-41de-a75c-e5f433325a18)

## IMPORTANT
If any sample policy has an issue, please do not contact Broadcom support. These demos are provided as-is. Please communicate via comments, pull requests and emails to the author of the demo if you have any issues or questions.

## Contribution Guidelines
To contribute sample policies, create a pull request with your updates. All pull requests require at least one reviewer to approve before the contribution will be merged to the main branch. Please ensure that all contributions follow the example of the "sample" above.
Each new sample should:
- Be located in "policy" folder or in an appropriate sub-folder where needed to group related policies
- If a subfolder is used, include a description in the README.md file in the folder with a description of the group
- Update the README.md on the main folder to add a name and brief description of the policy
- Comments must be added in the policy with an overview, dependencies and additional guidance if not included in the README or description section above

**Enjoy!**
