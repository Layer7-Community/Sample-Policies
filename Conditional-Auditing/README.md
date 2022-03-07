# Conditional Auditing
Enable auditing for specific services via a cluster-wide property. It sets up an encapsulated assertion that can be used in the global pre-services policy to influence the entire Gateway (recommended) or at the beginning of any service policy to enable the check for specific services.

Once deployed, access the demo service at /demo/conditionalAudit. Everything should be pretty self-evident from there.

# Deployment
`# ./GatewayMigrationUtility.sh migrateIn -h <host> -u <adminuser> --plaintextPassword <adminpassword> --trustCertificate --trustHostname -b Conditional-Auditing.bundle -r Conditional-Auditing.result`

