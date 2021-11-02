# JWK-Grok
JWK-Grok is a set of two API Gateway services to help understand how the JOSE features of the API Gateway work.

To deploy to a Gateway, use the GMU migrateIn command:

`# ./GatewayMigrationUtility.sh migrateIn -h <host> -u <adminuser> --plaintextPassword <adminpassword> --plaintextEncryptionPassphrase 7layer --trustCertificate --trustHostname -b JWK-Grok.bundle -r JWK-Grok.result`

Once deployed point your browser to http://&lt;gateway&gt;:8080/jwkSender

**Note**: All password requirements use '7layer'.

## Overview

Two identity keypairs, sender and recipient, were created using openssl and converted to JWK objects using the pem-to-jwk.sh script. The sender identity is used by the jwkSender service to sign a JWT and/or encrypt it to the recipient identity, per the test parameters. The jwkRecipient service then decrypts and/or validates the JWT, per the test parameters and returns a response summarising the effort.

Feel free to study the policies for a better understanding of the tests and how the Encode Json Web Token and Decode Json Web Token assertions work.

## Overview of the Tests

### Tests where no JOSE happens
- Test 1: sig:none, enc:none, val:none, decrypt:none

### Tests where no JWE happens
- Test 2: sig:keystore, enc:none, val:none, decrypt:none
- Test 3: sig:jwk, enc:none, val:none, decrypt:none
- Test 4: sig:keystore, enc:none, val:certificate, decrypt:none
- Test 5: sig:keystore, enc:none, val:jwk, decrypt:none
- Test 6: sig:jwk, enc:none, val:jwk, decrypt:none
- Test 7: sig:jwk, enc:none, val:certificate, decrypt:none

### Tests where no JWS happens
- Test 8: sig:none, enc:certificate, val:none, decrypt:none
- Test 9: sig:none, enc:jwk, val:none, decrypt:none
- Test 10: sig:none, enc:certificate, val:none, decrypt:keystore
- Test 11: sig:none, enc:certificate, val:none, decrypt:jwk
- Test 12: sig:none, enc:jwk, val:none, decrypt:keystore
- Test 13: sig:none, enc:jwk, val:none, decrypt:jwk

### Tests with full sender JOSE, no recipient JOSE
- Test 14: sig:keystore, enc:certificate, val:none, decrypt:none
- Test 15: sig:jwk, enc:certificate, val:none, decrypt:none
- Test 16: sig:keystore, enc:jwk, val:none, decrypt:none
- Test 17: sig:jwk, enc:jwk, val:none, decrypt:none

### Tests with full sender JOSE, recipient only JWE from keystore
- Test 18: sig:keystore, enc:certificate, val:none, decrypt:keystore
- Test 19: sig:jwk, enc:certificate, val:none, decrypt:keystore
- Test 20: sig:keystore, enc:jwk, val:none, decrypt:keystore
- Test 21: sig:jwk, enc:jwk, val:none, decrypt:keystore

### Tests with full sender JOSE, recipient only JWE from JWK
- Test 22: sig:keystore, enc:certificate, val:none, decrypt:jwk
- Test 23: sig:jwk, enc:certificate, val:none, decrypt:jwk
- Test 24: sig:keystore, enc:jwk, val:none, decrypt:jwk
- Test 25: sig:jwk, enc:jwk, val:none, decrypt:jwk

### Tests with full JOSE, recipient JWE from keystore
- Test 26: sig:keystore, enc:certificate, val:certificate, decrypt:keystore
- Test 27: sig:jwk, enc:certificate, val:jwk, decrypt:keystore
- Test 28: sig:keystore, enc:jwk, val:certificate, decrypt:keystore
- Test 29: sig:jwk, enc:jwk, val:jwk, decrypt:keystore

### Tests with full JOSE, recipient JWE from JWK
- Test 30: sig:keystore, enc:certificate, val:certificate, decrypt:jwk
- Test 31: sig:jwk, enc:certificate, val:jwk, decrypt:jwk
- Test 32: sig:keystore, enc:jwk, val:certificate, decrypt:jwk
- Test 33: sig:jwk, enc:jwk, val:jwk, decrypt:jwk

## Creating New Keys

### Create sender key pair:

`# openssl req -x509 -newkey rsa:4096 -days 3650 -passout pass:7layer -subj "/CN=sender" -keyout sender.key.pem -out sender.cer.pem`

### Generate the base64 file:
`# openssl x509 -in sender.cer.pem -outform der | base64 -w0 > sender.cer.b64`

### Catenate the key and certificate into a single file:
`# cat sender.key.pem sender.cer.pem > sender.pem`

### Convert it into a single pkcs12 .p12 file
`# openssl pkcs12 -export -passin pass:7layer -passout pass:7layer -name "Sender" -in sender.pem -out sender.p12`

### Generate the jwk files
`# ./pem-to-jwk.sh -k sender.key.pem -r sender -p 7layer`

### Create recipient key pair:
`# openssl req -x509 -newkey rsa:4096 -days 3650 -passout pass:7layer -subj "/CN=recipient" -keyout recipient.key.pem -out recipient.cer.pem`

### Generate the base64 file:
`# openssl x509 -in recipient.cer.pem -outform der | base64 -w0 > recipient.cer.b64`

### Catenate the key and certificate into a single file:
`# cat recipient.key.pem recipient.cer.pem > recipient.pem`

### Convert it into a single pkcs12 .p12 file
`# openssl pkcs12 -export -passin pass:7layer -passout pass:7layer -name "Recipient" -in recipient.pem -out recipient.p12`

### Generate the jwk files
`# ./pem-to-jwk.sh -k recipient.key.pem -r recipient -p 7layer`

### Create the JWKS:
`# ./catenate-jwk.sh *.jwk > keys.jwks`

## Deploying New Keys

1. Load sender.p12 into the private key store with alias='sender'
2. Load recipient.p12 into the private key store with alias='recipient'
3. Modify JWK Sender policy, in the "Assign the key variables" block:
    - Update ${sender.key.jwk} from file: sender.key.jwk
        - Remove "use" element
    - Update ${recipient.pub.jwk} from file: recipient.pub.jwk
        - Set "use" element to "enc"
    - Update ${recipient.cer.b64} from file: recipient.cer.b64
4. Modify JWK Recipient policy, in the "Assign the key variables" block:
    - Update ${recipient.key.jwk} from file: recipient.key.jwk
        - Remove "use" element
    - Update ${sender.pub.jwk} from file: sender.pub.jwk
        - Set "use" element to "sig"
    - Update ${sender.cer.b64} from file: sender.cer.b64
