({
	init : function(component, event) {
        var action = component.get('c.getClientAndDivisionIds');
        action.setParams({
            "recordId":component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                console.log('response.getReturnValue():'+response.getReturnValue());
                var splitResult = response.getReturnValue().split('$$$');
                component.set("v.clientIds",splitResult[0]);
                component.set("v.divisionIds",splitResult[1]);
            }else{
                ///alert('ERROR...');
            }
            component.set("v.showSpinner",false);
        });
        component.set("v.showSpinner",true);
        $A.enqueueAction(action);
	}
})