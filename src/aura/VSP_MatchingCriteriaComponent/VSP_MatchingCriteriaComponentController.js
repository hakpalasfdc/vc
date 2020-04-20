({
	 handleLoad : function(component, event, helper) {
        var recUi = event.getParam("recordUi");
         console.log('recUi:'+recUi);
     
     },
    doInit :  function(component, event, helper) {
        helper.init(component,event);
    },
    init :  function(component, event, helper) {//getClientAndDivisionIds
        console.log('init');
        /*if(component.get('v.isCreated')) {
            component.set('v.isCreated', false);
            setTimeout($A.getCallback(function() {
                $A.enqueueAction(component.get('c.init'));
                helper.init(component,event);
            }), 1000);
            return window.history.back();
        }*/
    },
	handleSubmit : function(component, event, helper) {
        event.preventDefault();
        component.set("v.showSpinner",true);
        var fields = event.getParam("fields");
        component.find("form").submit(fields);
        
    },
    handleSuccess : function(component, event, helper) {
        var record = event.getParam("response");
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been updated successfully."
        });
        toastEvent.fire();
        component.set("v.showSpinner",false);
	},
    handleClick: function(component, event, helper) {
        console.log('value:'+event.getSource().getLocalId());
        if(event.getSource().getLocalId() == 'clientid'){
        	var createRecordEvent = $A.get("e.force:createRecord");
            createRecordEvent.setParams({
                "entityApiName": "Alert_Client_ID_Criteria__c",
                "defaultFieldValues": {
                    'Alert__c' : component.get("v.recordId")
                },
                "panelOnDestroyCallback": function(event) {
                    console.log('test');
                }
            });
            console.log('firing');
            component.set('v.isCreated', true);
            createRecordEvent.fire();
        }else{
         var createRecordEvent = $A.get("e.force:createRecord");
            createRecordEvent.setParams({
                "entityApiName": "Alert_Division_ID_Criteria__c",
                "defaultFieldValues": {
                    'Alerts_and_Notifications__c' : component.get("v.recordId")
                }
            });
            createRecordEvent.fire();
             component.set('v.isCreated', true);
         }
	},
})