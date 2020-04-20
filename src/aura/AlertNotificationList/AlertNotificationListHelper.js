({
    init : function(component){
    	var pageSize = component.get("v.pageSize");
        var action = component.get("c.getAlertList");
        action.setParams({"recordId":component.get("v.recordId")});
        action.setCallback(this, function(response){
        	var state = response.getState();
            if (component.isValid() && state === "SUCCESS"){
        		component.set("v.attFullList", response.getReturnValue());
        		component.set("v.totalSize", component.get("v.attFullList").length);
        		//component.set("v.start",0);
                if(component.get("v.totalSize")>(component.get("v.end")+pageSize)){
        			component.set("v.end",component.get("v.end")+pageSize-1);
                    console.log('=====');
                }
                else{
                    console.log('---'+component.get("v.totalSize"));
                    component.set("v.end",component.get("v.totalSize")-1);
                }
                
                console.log('pagination data:'+JSON.stringify(response.getReturnValue()));
                console.log('pagination length:'+response.getReturnValue().length);
                var paginationList = [];
                for(var i=component.get("v.start"); i<= component.get("v.end"); i++){
                    if($A.util.isEmpty(response.getReturnValue()[i]))
                        break;
                	paginationList.push(response.getReturnValue()[i]);
                }
                component.set("v.paginationList", paginationList);
                console.log('totalSize:'+component.get("v.totalSize"));
                console.log('start:'+component.get("v.start"));
                console.log('end:'+component.get("v.end"));
            }
        
        });
        
        $A.enqueueAction(action);

	},
    handleRemove : function (component, alertId){
      var pageSize = component.get("v.pageSize");
      var action = component.get('c.removeAlerts');
        action.setParams({
            "alertId" : alertId,
            "recordId":component.get("v.recordId"),
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                component.set("v.attFullList", response.getReturnValue());
        		component.set("v.totalSize", component.get("v.attFullList").length);
        		component.set("v.start",0);
                component.set("v.end",0);
                if(component.get("v.totalSize")>(component.get("v.end")+pageSize)){
        			component.set("v.end",component.get("v.end")+pageSize-1);
                    console.log('=====');
                }
                else{
                    console.log('---'+component.get("v.totalSize"));
                    component.set("v.end",component.get("v.totalSize")-1);
                }
                
                console.log('pagination data:'+JSON.stringify(response.getReturnValue()));
                console.log('pagination length:'+response.getReturnValue().length);
                var paginationList = [];
                for(var i=component.get("v.start"); i<= component.get("v.end"); i++){
                    if($A.util.isEmpty(response.getReturnValue()[i]))
                        break;
                	paginationList.push(response.getReturnValue()[i]);
                }
                component.set("v.paginationList", paginationList);
                console.log('totalSize:'+component.get("v.totalSize"));
                console.log('start:'+component.get("v.start"));
                console.log('end:'+component.get("v.end"));
            }else{
                alert('ERROR...');
            }
            component.set("v.showSpinner",false);
        });
        component.set("v.showSpinner",true);
        $A.enqueueAction(action);
    }   
    
})