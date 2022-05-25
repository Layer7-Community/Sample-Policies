# Timestamp Difference Demo
Policy to illustrate how to calculate the difference between two timestamps submitted as query parameters

# Flow
Two date values are submitted in the url, which are converted to time/date variables then to seconds as a string, which are then used to calculate the delta between the timestamp in days using the Evaluate Response XPath assertion.

# Deployment
- Publish a Web API service via the Policy Manager
- Import the 'Timestamp Difference Demo.xml' file from this repository
- Access the service with a browser or curl to see the parsing result:

http://<gateway>:8080/test?date1=2022-05-20T10:15:03Z&date2=2022-05-25T05:00:01Z

Refer to inline comments for more information.
