# FCM Push Notification
This policy demonstrates how to send a message to a mobile device using FCM.
This policy generates a intermediate oAuth token to forward the messages to FCM.

Import Sample Policy 

•	Create a new Web API, specify a name such as "Send Notificationr" and a Gateway URL such as "/fcm/send"
•	From toolbar Import Policy, select the xml policy (save and active)
•	Follow the steps from documentation to customise the policy([https://techdocs.broadcom.com/us/en/ca-enterprise-software/layer7-api-management/mobile-api-gateway/4-2/configure-mag/enable-android-push-notification-service.html#:~:text=the%20GCM%20policies.-,Install%20the%20FCM%20Server%20SSL%20Certificates,-To%20securely%20forward](https://techdocs.broadcom.com/us/en/ca-enterprise-software/layer7-api-management/mobile-api-gateway/4-2/configure-mag/enable-android-push-notification-service.html)https://techdocs.broadcom.com/us/en/ca-enterprise-software/layer7-api-management/mobile-api-gateway/4-2/configure-mag/enable-android-push-notification-service.html)
•	Call the manager https://gateway:9443/fcm/send
