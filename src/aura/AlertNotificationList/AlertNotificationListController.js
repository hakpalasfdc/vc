({
    doInit: function(component,event,helper){
        var action = component.get('c.isAuthorUser');
        action.setCallback(this, function(response){
            component.set("v.showSpinner",false);
            var state = response.getState();
            if(state === 'SUCCESS'){
                console.log('response:'+JSON.stringify(response.getReturnValue()));
                component.set("v.isAuthor",response.getReturnValue());
                //helper.init(component);
            }
        });
		component.set("v.showSpinner",true);
        $A.enqueueAction(action);
        helper.init(component);
  
    },
    
    redirectToRecord : function(component, event, helper) {
        console.log('value:'+event.currentTarget.dataset.value);
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": event.currentTarget.dataset.value,
            "slideDevName": "related"
        });
        navEvt.fire();
    },
    handleRemoveClick: function(component, event, helper) {
    	var alertId = event.getSource().get("v.value");
        console.log('alertId:'+alertId);
        helper.handleRemove(component,alertId);
    },
    next : function(component, event, helper){
        console.log('totalSize:'+component.get("v.totalSize"));
        console.log('start:'+component.get("v.start"));
        console.log('end:'+component.get("v.end"));
        var alertList = component.get("v.attFullList");
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];
        var counter = 0;
        component.set("v.start",component.get("v.end")+1);
        if(component.get("v.totalSize")>(component.get("v.end")+pageSize))
            component.set("v.end",component.get("v.end")+pageSize);
        else
            component.set("v.end",component.get("v.totalSize")-1);
        
        
        
        for(var i=component.get("v.start"); i<= component.get("v.end"); i++){
                if($A.util.isEmpty(alertList[i]))
                   break;
                paginationList.push(alertList[i]);
            }
        
        //start = start + counter;
       //end = end + counter;
       	/*start = start + end;
        end = end + counter;
        component.set("v.start",start);
        component.set("v.end",end);*/
    	component.set("v.paginationList", paginationList);
        
        console.log('-totalSize:'+component.get("v.totalSize"));
        console.log('-start:'+component.get("v.start"));
        console.log('-end:'+component.get("v.end"));
   },
    previous : function(component, event, helper){
        console.log('totalSize:'+component.get("v.totalSize"));
        console.log('start:'+component.get("v.start"));
        console.log('end:'+component.get("v.end"));
        
    	var alertList = component.get("v.attFullList");
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];
        var counter = 0;
        component.set("v.end",component.get("v.start")-1);
        component.set("v.start",component.get("v.start")-pageSize);
        
        for(var i=component.get("v.start"); i<= component.get("v.end"); i++){
            if($A.util.isEmpty(alertList[i]))
                break;
            paginationList.push(alertList[i]);
        }
       /* start = start - counter;
        end = end - counter;
        component.set("v.start",start);
        component.set("v.end",end);*/
        component.set("v.paginationList", paginationList);
        console.log('=totalSize:'+component.get("v.totalSize"));
        console.log('=start:'+component.get("v.start"));
        console.log('=end:'+component.get("v.end"));
    }
})