# Gateway As Password Vault
This policy sets up a simple password vault on the Gateway that accesses encrypted passwords stored in the Secure Password Store on the Gateway. It can be used by the manage_binlogs.sh and audit_purge.sh scripts that both mention using a service on the Gateway to provide the passwords used by the scripts in lieu of hardcoding them, or by other local scripts as required.

It requires each password to be set up in the 'Tasks -> Certificates, Keys and Secrets -> Manage Stored Passwords' with the 'Permit use via context variable reference' box checked. That checkbox means that policies can obtain the plaintext of a password that is encrypted in the database by referencing the ${secpass.&lt;pwdname&gt;.plaintext} context variable.

In the manage_binlogs.sh and audit_purge.sh scripts there are lines for setting DBPWD and ROOTDBPWD that are normally hard coded but that can call wget (or curl) to obtain the password at runtime, so we publish a Web API type endpoint at /getPwd on the Gateway to do this. Since this endpoint is delivering the password in the clear we need to set up security on it, and IMO checking that the call is over SSL and from localhost is the minimum and, in most cases, is strong enough. Beyond that it becomes a lesson in security through obscurity, since some passphrase is going to be required to unlock further security to make the call, and if that is the case then you might as well just put the passwords you are trying to get in whatever vault you use to get the password from the service.

Did that make sense? :) To be honest, if you have an existing password vault that can be called from a shell script I recommend using that, since it has probably already been cleared by your security team.

# Risks
The following risks need to be considered:

  - If someone gains access to the Gateway using the Policy Manager or Restman they can publish their own service to simply return the password without any security on it
  - If someone gains root access to the OS they can just call the service directly from localhost to get the password in the clear

In both cases there has already been a pretty major security breach, so it depends on your security requirements as to whether that level of risk is acceptable. The advantage is that the passwords are never stored in the clear.

# Deployment
- Set up the passwords to be delivered in the 'Task -> Certificates, Keys and Secrets -> Manage Stored Passwords' interface, ensuring that the 'Permit use via context variable reference' box is checked for each.
- Publish a service at /getPwd and load the getPwd.xml policy into it.
- Modify the policy to match the passwords that can be delivered by the service. Note that each password will need its own block in the *// Retrieve password for name set in ${request.http/parameter.p}* block. The names MUST match the names set in the 'Tasks -> Certificates, Keys and Secrets -> Manage Stored Passwords' step above.

# Testing
You can use curl or wget the test the service:

    # curl -k https://localhost:8443/getPwd?p=dbreplpwd
    # wget -O- -q --no-check-certificate https://localhost:8443d?p=dbreplpwd

The following test should succeed:

- Call https://localhost:8443/getPwd?p=&lt;password&gt; where &lt;password&gt; matches a password set up in the policy

The following tests should result in a closed connection:

- Call from a non-localhost IP addresses
- Call from localhost and remote IP address to non-ssl endpoint (port 8080)
- Call with a password not recognised by the policy
