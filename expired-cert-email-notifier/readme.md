Expired Trusted Certificate Notification Service

This sample policy uses the REST Manage Gateway assertion to provide a simple notification service for any trusted certificates that are on the gateway. The service sends emails for any certificates it finds to have expired. 

Import Sample Policy 

+ Create a new policy (Tasks > Services & APIs), specify a name such as "certificates checker". Set ‘Policy Type’ to ‘Policy-Backed Service operation Policy Fragment’. Set ‘Policy Tag’ to ‘com.l7tech.objectmodel.polback.BackgroundTask’
+ From toolbar Import Policy, select the xml policy
+ Set the variables at the top of the policy for email settings, servers etc. Its recommended that you use a secure password for the email assertion (line 38 ) if required.
+ Customise the email assertion content if you want to change the message sent to the email target. (for some mail servers you may need to change the settings of this assertion , such as Protocol, Port etc. You may also need to install the cert of the mail server to the gateway)
+	From the Task > Global settings menu choose ‘Manage Scheduled Tasks’
+	Add a new task, give a name such as ‘Cert checker Task’, choose the policy from the drop down list and set the schedule you require, for example once a day.
+	Ensure you Choose ‘Execute policy with user’ and choose a user with admin rights.

Using the example

The task will send an email to the target for each certificate found with and expiry date in the past.

