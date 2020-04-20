({
    Change1: function(cmp, evt, helper) {
        var vreset = cmp.get("v.reset");
        cmp.set("v.tab", "1");
        if (vreset=="0") {
        helper.helper1(cmp, evt, helper);
        }
    },
    Change2: function(cmp, evt, helper) { 
        var vreset = cmp.get("v.reset");
        cmp.set("v.tab", "2");
        if (vreset=="0") 
        helper.helper2(cmp, evt, helper);
    },
    Change3: function(cmp, evt, helper) {
        var vreset = cmp.get("v.reset");
        cmp.set("v.tab", "3");
        if (vreset=="0") 
        helper.helper3(cmp, evt, helper);
    },
    Change4: function(cmp, evt, helper) {
        var vreset = cmp.get("v.reset");
        cmp.set("v.tab", "4");
        if (vreset=="0") 
        helper.helper4(cmp, evt, helper);
    },
    Change5: function(cmp, evt, helper) {
        var vreset = cmp.get("v.reset");
        cmp.set("v.tab", "5");
        if (vreset=="0") 
        helper.helper5(cmp, evt, helper);
    },
    Change6: function(cmp, evt, helper) {
        var vreset = cmp.get("v.reset");
        cmp.set("v.tab", "6");
        if (vreset=="0") 
        helper.helper6(cmp, evt, helper);
    },
clear: function(cmp, evt, helper) {
    cmp.set("v.reset", "1");
    cmp.set("v.copay", "0");
    cmp.set("v.copay3", "0");
    cmp.set("v.ucfee", "0");
    cmp.set("v.exam1", "0");
    cmp.set("v.lens1", "0");
    cmp.set("v.frame1", "0");
    cmp.set("v.other1", "0");
    cmp.set("v.exam31", "0");
    cmp.set("v.other31", "0");
    cmp.set("v.exam22", "0");
    cmp.set("v.lens22", "0");
    cmp.set("v.frame22", "0");
    cmp.set("v.other22", "0");
    cmp.set("v.exam23", "0");
    cmp.set("v.lens23", "0");
    cmp.set("v.frame23", "0");
    cmp.set("v.other23", "0");
    cmp.set("v.exam32", "0");
    cmp.set("v.other32", "0");
    cmp.set("v.exam33", "0");
    cmp.set("v.other33", "0");
    cmp.set("v.exam41", "0");
    cmp.set("v.exam42", "0");
    cmp.set("v.exam43", "0");
    cmp.set("v.lens41", "0");
    cmp.set("v.lens42", "0");
    cmp.set("v.lens43", "0");
    cmp.set("v.other41", "0");
    cmp.set("v.other42", "0");
    cmp.set("v.other43", "0");
    cmp.set("v.lens53", "0");
    cmp.set("v.exam52", "0");
    cmp.set("v.exam53", "0");
    cmp.set("v.lens61", "0");
    cmp.set("v.lens62", "0");
    cmp.set("v.lens63", "0");
    cmp.set("v.exam61", "0");
    cmp.set("v.exam62", "0");
    cmp.set("v.exam63", "0");
    cmp.set("v.exam2", "0");
    cmp.set("v.exam3", "0");
    cmp.set("v.exam22", "0");
    cmp.set("v.exam23", "0");
    cmp.set("v.exam4", "0");
    cmp.set("v.exam5", "0");
    cmp.set("v.exam6", "0");
    cmp.set("v.lens2", "0");
    cmp.set("v.lens3", "0");
    cmp.set("v.lens4", "0");
    cmp.set("v.lens5", "0");
    cmp.set("v.lens6", "0");
    cmp.set("v.frame2", "0");
    cmp.set("v.frame3", "0");
    cmp.set("v.frame4", "0");
    cmp.set("v.frame5", "0");
    cmp.set("v.frame6", "0");
    cmp.set("v.other2", "0");
    cmp.set("v.other3", "0");
    cmp.set("v.other4", "0");
    cmp.set("v.other5", "0");
    cmp.set("v.other6", "0");
    cmp.set("v.total4", "0");
    cmp.set("v.total5", "0");
    cmp.set("v.total6", "0");
    cmp.set("v.reset", "0");
    },
  
    hdlRadio : function(cmp, evt, helper){

        if (evt.getSource().get('v.value')==true) {
            var voption=evt.getSource().get('v.label');
            cmp.set("v.selectedOption", voption);
        }
    },
    
    copytocase: function(cmp, evt, helper) {
        var vtab = cmp.get("v.tab");
        if (vtab>"0"&&vtab<"7") {
            var voption = cmp.get("v.selectedOption");
            if (voption>"0"&&voption<"4") 
                helper.copytocase_helper(cmp, vtab, voption);
            else 
                alert("Please select a result to copy.");
        }
        else alert("Please provide inputs.");
    }

})