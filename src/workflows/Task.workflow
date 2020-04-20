<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>Reward_Tasks_on_Opportunities</fullName>
        <apiVersion>33.0</apiVersion>
        <endpointUrl>http://bvprod.herokuapp.com/applyBehavior?site_id=559ab8fa880af164a20004bd&amp;api_key=7dbbb92700891a2a06bdfcda06a91395&amp;sf_instance=na12&amp;behaviorId=a1CU0000003iMjvMAE</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>katherineb@vsp.com</integrationUser>
        <name>Reward Completed Tasks on Opportunities</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <tasks>
        <fullName>Badgeville_Test</fullName>
        <assignedTo>katherineb@vsp.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Task.ActivityDate</offsetFromField>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Badgeville Test</subject>
    </tasks>
</Workflow>
