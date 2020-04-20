({ 
helper1 : function(cmp, evt, helper) {
        var vexam4, vexam5, vexam6;
        var exam1Field = cmp.find("exam1");
        var vexam1 = exam1Field.get("v.value");
        var exam2Field = cmp.find("exam2");
        var vexam2 = exam2Field.get("v.value");
        var exam3Field = cmp.find("exam3");
        var vexam3 = exam3Field.get("v.value");
        //=IF(D16>C16,C16,IF(D16=C16,C16,IF(D16<C16,D16,"")))
        if (vexam3-vexam1<vexam2) 
           vexam4=vexam3-vexam1;
        else 
           vexam4=vexam2;
//=IF(E16=0,0,IF(E16*1.5>=D16-C7,D16-C7,E16*1.5))
        if (vexam4==0) vexam5=0;
        else {if (vexam4*1.5>=vexam3-vexam1) 
           vexam5=vexam3-vexam1;
        else 
            vexam5=vexam4*1.5;} 
//=IF(E16=0,0,IF(E16*2>=D16-C7,D16-C7,E16*2))
        if (vexam4==0) vexam6=0;
        else {if (vexam4*2>=vexam3-vexam1) 
           vexam6=vexam3-vexam1;
        else 
            vexam6=vexam4*2;}     
        cmp.set("v.exam4", vexam4);
        cmp.set("v.exam5", vexam5);
        cmp.set("v.exam6", vexam6);
var vlens4, vlens5, vlens6;
var vframe4, vframe5, vframe6;
var vother4, vother5, vother6;
var vlens14, vlens15, vlens16;
var vlens24, vlens25, vlens26;
var vframe14, vframe15, vframe16;
var vframe24, vframe25, vframe26;
var temp;
        var lens1Field = cmp.find("lens1");
        var vlens1 = lens1Field.get("v.value");
        var lens2Field = cmp.find("lens2");
        var vlens2 = lens2Field.get("v.value");
        var lens3Field = cmp.find("lens3");
        var vlens3 = lens3Field.get("v.value");
        var frame1Field = cmp.find("frame1");
        var vframe1 = frame1Field.get("v.value");
        var frame2Field = cmp.find("frame2");
        var vframe2 = frame2Field.get("v.value");
        var frame3Field = cmp.find("frame3");
        var vframe3 = frame3Field.get("v.value");
        var other1Field = cmp.find("other1");
        var vother1 = other1Field.get("v.value");
        var other2Field = cmp.find("other2");
        var vother2 = other2Field.get("v.value");
        var other3Field = cmp.find("other3");
        var vother3 = other3Field.get("v.value");
    //E29=lens14=IF(D17=0,0,IF((D17-C8-C10-C11)>=C17,C17,IF((D17-C8-C10-C11)<C17,D17-C8-C10-C11))) 
        temp=vlens3-vlens1-vother1;
        if (vlens3==0) {
           vlens14=0;
        }
        else {
            if (temp*1>=vlens2*1) 
                vlens14=vlens2;
            else  
                vlens14=temp;
        }    
//F29=lens15=IF(D17=0,0,IF(E29*1.5>=D17-C10,D17-C8-C10-C11,E29*1.5))
        if (vlens3==0) {
           vlens15=0;
        }
        if (vlens4>130) {
           vlens15=vlens4;
        }
        else {
            if (vlens14*1.5>=temp*1) 
                vlens15=temp;
            else  
                vlens15=vlens14*1.5;
        }   
//lens16=IF(D17=0,0,IF(E29*2>=D17-C8-C10,D17-C8-C10-C11,E29*2))
        if (vlens3==0) {
           vlens16=0;
        }
        if (vlens4>130) {
           vlens16=vlens4;
        }
        else {
            if (vlens14*2>=temp*1) 
                vlens16=temp;
            else  
                vlens16=vlens14*2;
        }  
//lens24=IF(D17=0,0,IF((D17-C8-C9-C11)>C17,C17,IF((D17-C8-C9-C11)=C17,C17,IF((D17-C8-C9-C11)<C17,D17-C8-C9-C11,""))))
        if (vlens3==0) {
           vlens24=0;
        }
        else {
            if (temp>=vlens2*1) 
                vlens24=vlens2;
            else  
                vlens24=temp;
        }  
//lens25=IF(E33*1.5>=D17-C8-C11,D17-C8-C11,E33*1.5)
        if (vlens24*1.5>=vlens3-vlens1) {
           vlens25=vlens3-vlens1;
        }
        else {
           vlens25=vlens24*1.5;
        }  
//lens26=IF(E33*2>=D17-C8-C11,D17-C8-C11,E33*2)
        if (vlens24*2>=vlens3-vlens1) {
           vlens26=vlens3-vlens1;
        }
        else {
           vlens26=vlens24*2;
        }  
//=IF(D19>C19,C19,IF(D19=C19,C19,IF(D19<C19,D19,"")))
        if (vother3-vother1>=vother2*1) 
           vother4=vother2;
        else 
           vother4=vother3-vother1;
//=IF(E19*1.5>=D19-C5,D19-C5,E19*1.5)
        if (vother4>130) {
           vother5=vother4;
        }
    else {
        if (vother4*1.5>=vother3-vother1) 
           vother5=vother3-vother1;
        else 
            vother5=vother4*1.5;
    } 
//=IF(E19*2>=D19-C5,D19-C5,E19*2)
        if (vother4>130) {
           vother6=vother4;
        }
    else {
    if (vother4*2>=vother3-vother1) 
           vother6=vother3-vother1;
        else 
           vother6=vother4*2;
    }
//=IF(C17<0,0,IF(D28=1,E29,IF(D28=2,E33,IF(C11>0,#REF!))))
        if (vlens2==0) vlens4=0;
        else {
            if (vlens3>vframe3) vlens4=vlens24;
            else vlens4=vlens14;
        }
    
        temp=vframe3-vframe1-vother1;
        if (temp>=vframe2) 
           vframe14=vframe2;
        else 
           vframe14=temp;

//frame15=IF(D18=0,0,IF(E30*1.5>=D18-C11,D18-C9-C11-C12,E30*1.5))
        if (vframe3==0) {
           vframe15=0;
        }
        else {
            if (vframe14*1.5>=vframe3-vother1) 
                vframe15=temp;
            else  
                vframe15=vframe14*1.5;
        }   
//frame16=IF(D30=0,0,IF(E30*2>=D30-C11,D30-C9-C11-C12,E30*2))
        if (vframe3==0) {
           vframe16=0;
        }
        else {
            if (vframe14*2>=vframe3-vother1) 
                vframe16=temp;
            else  
                vframe16=vframe14*2;
        }  
//frame24=IF(D18=0,0,IF((D18-C9-C10-C11)>C18,C18,IF((D18-C9-C10-C11)=C18,C18,IF((D18-C9-C10-C11)<C18,D18-C9-C10-C11,""))))
        if (vframe3==0) 
            vframe24=0;
        else {
           if (temp>=vframe2) 
              vframe24=vframe2;
           else
              vframe24=temp;
        }
//frame25=IF(C18=0,0,IF(C18*1.5>D18-C9-C10-C11,D18-C9-C10-C11,IF(C18*1.5>130,130,C18*1.5)))
        if (vframe2==0) {
           vframe25=0;
        }
        else {
            if (vframe2*1.5>=temp) 
                vframe25=temp;
            else { 
                if (vframe2*1.5>130)
                    vframe25=130;
                else
                    vframe25=vframe2*1.5;
            }
        } 
//frame26=IF(C18=0,0,IF(C18*2>D18-C9-C10-C11,D18-C9-C10-C11,IF(C18*2>130,130,C18*2)))
        if (vframe2==0) {
           vframe26=0;
        }
        else {
            if (vframe2*2>=temp) 
                vframe26=temp;
            else {  
                if (vframe2*2>130) 
                    vframe26=130;
                else
                    vframe26=vframe2*2;
            }
        }  
          
        //=IF(C17<0,0,IF(D28=1,E29,IF(D28=2,E33,IF(C11>0,#REF!))))
        if (vframe2==0) vframe4=0;
        else {
            if (vlens3*1>vframe3*1) vframe4=vframe24;
            else vframe4=vframe14;
        }
//=IF(D28=1,F29,IF(D28=2,F33))
        if (vlens3*1>vframe3*1) vframe5=vframe25;
        else vframe5=vframe15;
//=IF(D28=1,G29,IF(D28=2,G33))
        if (vlens3*1>vframe3*1) vframe6=vframe25;
         else vframe6=vframe15;
//=IF(D28=1,F29,IF(D28=2,F33))
        if (vlens3*1>vframe3*1) vlens5=vlens15;
        else vlens5=vlens25;
//=IF(D28=1,G29,IF(D28=2,G33))
        if (vlens3*1>vframe3*1) vlens6=vlens16;
        else vlens6=vlens26;
    if (vexam4*1>vexam2*1) vexam4=vexam2;
    if (vlens4*1>vlens2*1) vlens4=vlens2;
    if (vframe4*1>vframe2*1) vframe4=vframe2;
    if (vother4*1>vother2*1) vother4=vother2;
    if (vlens4*1>130) {
        vlens5=vlens4;
        vlens6=vlens4;
    }
    if (vframe4*1>130) {
        vframe5=vframe4;
        vframe6=vframe4;
    }
    if (vexam4*1>130) {
        vexam5=vexam4;
        vexam6=vexam4;
    }
    if (vother4*1>=130) {
        vother5=vother4;
        vother6=vother4;
    }
        cmp.set("v.exam4", vexam4);
        cmp.set("v.exam5", vexam5);
        cmp.set("v.exam6", vexam6);
        cmp.set("v.lens4", vlens4);
        cmp.set("v.lens5", vlens5);
        cmp.set("v.lens6", vlens6);
        cmp.set("v.frame4", vframe4);
        cmp.set("v.frame5", vframe5);
        cmp.set("v.frame6", vframe6);
        cmp.set("v.other4", vother4);
        cmp.set("v.other5", vother5);
        cmp.set("v.other6", vother6);
        if (vexam4<0) vexam4=0;
        if (vlens4<0) vlens4=0;
        if (vframe4<0) vframe4=0;
        if (vother4<0) vother4=0;
        if (vexam5<0) vexam5=0;
        if (vlens5<0) vlens5=0;
        if (vframe5<0) vframe5=0;
        if (vother5<0) vother5=0;
        if (vexam6<0) vexam6=0;
        if (vlens6<0) vlens6=0;
        if (vframe6<0) vframe6=0;
        if (vother6<0) vother6=0;
        cmp.set("v.total4", vexam4*1+vlens4*1+vframe4*1+vother4*1); 
        cmp.set("v.total5", vexam5*1+vlens5*1+vframe5*1+vother5*1); 
        cmp.set("v.total6", vexam6*1+vlens6*1+vframe6*1+vother6*1);
        cmp.set("v.tab","1");
    },
    
helper2 : function(cmp, evt, helper) {
		var vexam4, vexam5, vexam6;
        var vlens4, vlens5, vlens6;
        var vframe4, vframe5, vframe6;
		var vother4, vother5, vother6;
        var copayused=0;
        var exam22Field = cmp.find("exam22");
        var vexam22 = exam22Field.get("v.value");
        var exam23Field = cmp.find("exam23");
        var vexam23 = exam23Field.get("v.value");
        var lens22Field = cmp.find("lens22");
        var vlens22 = lens22Field.get("v.value");
        var lens23Field = cmp.find("lens23");
        var vlens23 = lens23Field.get("v.value");
        var frame22Field = cmp.find("frame22");
        var vframe22 = frame22Field.get("v.value");
        var frame23Field = cmp.find("frame23");
        var vframe23 = frame23Field.get("v.value");
        var other22Field = cmp.find("other22");
        var vother22 = other22Field.get("v.value");
        var other23Field = cmp.find("other23");
        var vother23 = other23Field.get("v.value");
        var copayField = cmp.find("copay");
        var vcopay = copayField.get("v.value");
        if (vexam23*1>=vexam22*1) 
           vexam4=vexam22;
        else 
           vexam4=vexam23;
        if (vlens23*1>=vlens22*1) 
           vlens4=vlens22;
        else 
           vlens4=vlens23;

        if (vframe23*1>=vframe22*1) 
           vframe4=vframe22;
        else 
           vframe4=vframe23;

        if (vother23*1>=vother22*1) 
           vother4=vother22;
        else 
           vother4=vother23;

    if (vexam4*1>vexam22*1) vexam4=vexam22;
    if (vlens4*1>vlens22*1) vlens4=vlens22;
    if (vframe4*1>vframe22*1) vframe4=vframe22;
    if (vother4*1>vother22*1) vother4=vother22;

    
    	if (vlens4*1.5>=vlens23-vcopay) {
           copayused=1; 
           vlens5=vlens23-vcopay;
	    }
        else { 
           vlens5=vlens4*1.5;
        }
    	if (vlens4*2>=vlens23-vcopay) { 
           vlens6=vlens23-vcopay;
        }
        else {  
           vlens6=vlens4*2;
        }   
        if (vexam4*1.5>=vexam23*1.0) {
           vexam5=vexam23;
	    }
        else { 
           vexam5=vexam4*1.5;
        }
    	if (vexam4*2>=vexam23*1.0) { 
           vexam6=vexam23;
        }
        else {  
           vexam6=vexam4*2;
        }       
        if (vother4*1.5>=vother23*1) {
           vother5=vother23;
	    }
        else { 
           vother5=vother4*1.5;
        }
    	if (vother4*2>=vother23*1) { 
           vother6=vother23;
        }
        else {  
           vother6=vother4*2;
        }   
        
    if (copayused==0) {
    	if (vframe4*1.5>=vframe23-vcopay) {
           vframe5=vframe23-vcopay;
	    }
        else { 
           vframe5=vframe4*1.5;
        }
    	if (vframe4*2>=vframe23-vcopay) { 
           vframe6=vframe23-vcopay;
        }
        else {  
           vframe6=vframe4*2;
        }
    }
    else {
    	if (vframe4*1.5>=vframe23*1) {
           vframe5=vframe23;
	    }
        else { 
           vframe5=vframe4*1.5;
        }
    	if (vframe4*2>=vframe23*1) { 
           vframe6=vframe23;
        }
        else {  
           vframe6=vframe4*2;
        } 
    }    
    if (vlens4*1>130) {
        vlens5=vlens4;
        vlens6=vlens4;
    }
    if (vframe5*1>130) vframe5=130;
    if (vframe6*1>130) vframe6=130;
    if (vframe4*1>130) {
        vframe5=vframe4;
        vframe6=vframe4;
    }
    if (vexam4*1>130) {
        vexam5=vexam4;
        vexam6=vexam4;
    }
    if (vother4*1>130) {
        vother5=vother4;
        vother6=vother4;
    }
        cmp.set("v.exam4", vexam4);
        cmp.set("v.exam5", vexam5);
        cmp.set("v.exam6", vexam6);
        cmp.set("v.lens4", vlens4);
        cmp.set("v.lens5", vlens5);
        cmp.set("v.lens6", vlens6);
        cmp.set("v.frame4", vframe4);
        cmp.set("v.frame5", vframe5);
        cmp.set("v.frame6", vframe6);
        cmp.set("v.other4", vother4);
        cmp.set("v.other5", vother5);
        cmp.set("v.other6", vother6);        
        if (vexam4<0) vexam4=0;
        if (vlens4<0) vlens4=0;
        if (vframe4<0) vframe4=0;
        if (vother4<0) vother4=0;
        if (vexam5<0) vexam5=0;
        if (vlens5<0) vlens5=0;
        if (vframe5<0) vframe5=0;
        if (vother5<0) vother5=0;
        if (vexam6<0) vexam6=0;
        if (vlens6<0) vlens6=0;
        if (vframe6<0) vframe6=0;
        if (vother6<0) vother6=0;
        cmp.set("v.total4", vexam4*1+vlens4*1+vframe4*1+vother4*1); 
        cmp.set("v.total5", vexam5*1+vlens5*1+vframe5*1+vother5*1); 
        cmp.set("v.total6", vexam6*1+vlens6*1+vframe6*1+vother6*1);
        cmp.set("v.tab","2");
    },

helper3 : function(cmp, evt, helper) {
		var vexam4, vexam5, vexam6;
		var vother4, vother5, vother6;
    
        var copay3Field = cmp.find("copay3");
        var vcopay3 = copay3Field.get("v.value");
        
        var exam31Field = cmp.find("exam31");
        var vexam31 = exam31Field.get("v.value");
        var exam32Field = cmp.find("exam32");
        var vexam32 = exam32Field.get("v.value");
        var exam33Field = cmp.find("exam33");
        var vexam33 = exam33Field.get("v.value");
        var other31Field = cmp.find("other31");
        var vother31 = other31Field.get("v.value");
        var other32Field = cmp.find("other32");
        var vother32 = other32Field.get("v.value");
        var other33Field = cmp.find("other33");
        var vother33 = other33Field.get("v.value");
        if (vcopay3*1>=0) vother31=vcopay3; 
        if (vexam33-vexam31>=vexam32*1) 
           vexam4=vexam32;
        else 
           vexam4=vexam33-vexam31;
    
        if (vother33-vother31>=vother32*1) 
           vother4=vother32;
        else 
           vother4=vother33-vother31;
    
        if (vexam4*1.5>=vexam33-vexam31) {
           vexam5=vexam33-vexam31;
	    }
        else { 
           vexam5=vexam4*1.5;
        }
    	if (vexam4*2>=vexam33-vexam31) { 
           vexam6=vexam33-vexam31;
        }
        else {  
           vexam6=vexam4*2;
        }       
        if (vother4*1.5>=vother33-vother31) {
           vother5=vother33-vother31;
	    }
        else { 
           vother5=vother4*1.5;
        }
    	if (vother4*2>=vother33-vother31) { 
           vother6=vother33-vother31;
        }
        else {  
           vother6=vother4*2;
        }           
    if (vexam4*1>vexam32*1) vexam4=vexam32;
    if (vother4*1>vother32*1) vother4=vother32;

    if (vother5*1>130) vother5=130;
    if (vother6*1>130) vother6=130;
    if (vother4*1>130) {
        vother5=vother4;
        vother6=vother4;
    }
        cmp.set("v.exam4", vexam4);
        cmp.set("v.exam5", vexam5);
        cmp.set("v.exam6", vexam6);
        cmp.set("v.other4", vother4);
        cmp.set("v.other5", vother5);
        cmp.set("v.other6", vother6);
        if (vexam4<0) vexam4=0;
        if (vother4<0) vother4=0;
        if (vexam5<0) vexam5=0;
        if (vother5<0) vother5=0;
        if (vexam6<0) vexam6=0;
        if (vother6<0) vother6=0;
        cmp.set("v.total4", vexam4*1+vother4*1); 
        cmp.set("v.total5", vexam5*1+vother5*1); 
        cmp.set("v.total6", vexam6*1+vother6*1);
        cmp.set("v.tab","3");
    },
    
helper4 : function(cmp, evt, helper) {
        var vucfee="0", vlens4 ="0";
        var vexam4, vexam5, vexam6;
		var vother4, vother5, vother6;
        var exam41Field = cmp.find("exam41");
        var vexam41 = exam41Field.get("v.value");
        var exam42Field = cmp.find("exam42");
        var vexam42 = exam42Field.get("v.value");
        var exam43Field = cmp.find("exam43");
        var vexam43 = exam43Field.get("v.value");
        var ucfeeField = cmp.find("ucfee");
        var vucfee = ucfeeField.get("v.value");
        var lens41Field = cmp.find("lens41");
        var vlens41 = lens41Field.get("v.value");
        var other41Field = cmp.find("other41");
        var vother41 = other41Field.get("v.value");
        var other42Field = cmp.find("other42");
        var vother42 = other42Field.get("v.value");
        var other43Field = cmp.find("other43");
        var vother43 = other43Field.get("v.value");
        if (vucfee=="0") cmp.set("v.lens42", "0"); 
        else cmp.set("v.lens42", vucfee*0.85);
        cmp.set("v.lens43", vucfee*1);
        vlens4=vucfee*0.85-vlens41*1;
        if (vlens4*1>130) vlens4=vucfee*0.85;
        cmp.set("v.lens4", vlens4);
        cmp.set("v.lens5", vlens4);
        cmp.set("v.lens6", vlens4);
        if (vexam43-vexam41>=vexam42*1) 
           vexam4=vexam42;
        else 
           vexam4=vexam43-vexam41;

        if (vother43-vexam41>=vother42*1) 
           vother4=vother42;
        else 
           vother4=vother43-vexam41;
    
        if (vexam4*1.5>=vexam43-vexam41) {
           vexam5=vexam43-vexam41;
	    }
        else { 
           vexam5=vexam4*1.5;
        }
    	if (vexam4*2>=vexam43-vexam41) { 
           vexam6=vexam43-vexam41;
        }
        else {  
           vexam6=vexam4*2;
        }       
        if (vother4*1.5>=vother43-vother41) {
           vother5=vother43-vother41;
	    }
        else { 
           vother5=vother4*1.5;
        }
    	if (vother4*2>=vother43-vother41) { 
           vother6=vother43-vother41;
        }
        else {  
           vother6=vother4*2;
        }           
    if (vexam4*1>vexam42*1) vexam4=vexam42;
    if (vother4*1>vother42*1) vother4=vother42;
    if (vexam5*1>130) vexam5=130;
    if (vexam6*1>130) vexam6=130;
    if (vexam4*1>130) {
        vexam5=vexam4;
        vexam6=vexam4;
    }
    if (vother5*1>130) vother5=130;
    if (vother6*1>130) vother6=130;
    if (vother4*1>130) {
        vother5=vother4;
        vother6=vother4;
    }
        cmp.set("v.exam4", vexam4);
        cmp.set("v.exam5", vexam5);
        cmp.set("v.exam6", vexam6);
        cmp.set("v.other4", vother4);
        cmp.set("v.other5", vother5);
        cmp.set("v.other6", vother6);
        if (vexam4<0) vexam4=0;
        if (vother4<0) vother4=0;
        if (vexam5<0) vexam5=0;
        if (vother5<0) vother5=0;
        if (vexam6<0) vexam6=0;
        if (vother6<0) vother6=0;
        if (vlens4<0) vlens4=0;
        cmp.set("v.total4", vexam4*1+vlens4+vother4*1); 
        cmp.set("v.total5", vexam5*1+vlens4+vother5*1); 
        cmp.set("v.total6", vexam6*1+vlens4+vother6*1);
        cmp.set("v.tab","4");
    },

helper5 : function(cmp, evt, helper) {
		var vexam4, vexam5, vexam6;
        var exam52Field = cmp.find("exam52");
        var vexam52 = exam52Field.get("v.value");
        var exam53Field = cmp.find("exam53");
        var vexam53 = exam53Field.get("v.value");
        var lens53Field = cmp.find("lens53");
        var vlens53 = lens53Field.get("v.value");
        var vreceipts=vexam53*1+vlens53*1;
        if (vreceipts*1>=vexam52*1) 
           vexam4=vexam52;
        else 
           vexam4=vreceipts;
    
        if (vexam4*1.5>=vreceipts*1) {
           vexam5=vreceipts;
	    }
        else { 
           vexam5=vexam4*1.5;
        }
    	if (vexam4*2>=vreceipts*1) { 
           vexam6=vreceipts;
        }
        else {  
           vexam6=vexam4*2;
        }       
    if (vexam4*1>vexam52*1) vexam4=vexam52;
    if (vexam5*1>130) vexam5=130;
    if (vexam6*1>130) vexam6=130;
    if (vexam4*1>130) {
        vexam5=vexam4;
        vexam6=vexam4;
    }
        cmp.set("v.exam4", vexam4);
        cmp.set("v.exam5", vexam5);
        cmp.set("v.exam6", vexam6);
        cmp.set("v.total4", vexam4); 
        cmp.set("v.total5", vexam5); 
        cmp.set("v.total6", vexam6);
        cmp.set("v.tab","5");
    },

helper6 : function(cmp, evt, helper) {
        var vexam4, vexam5, vexam6;
        var vlens4, vlens5, vlens6;

        var exam61Field = cmp.find("exam61");
        var vexam61 = exam61Field.get("v.value");
        var exam62Field = cmp.find("exam62");
        var vexam62 = exam62Field.get("v.value");
        var exam63Field = cmp.find("exam63");
        var vexam63 = exam63Field.get("v.value");
        var lens61Field = cmp.find("lens61");
        var vlens61 = lens61Field.get("v.value");
        var lens62Field = cmp.find("lens62");
        var vlens62 = lens62Field.get("v.value");
        var lens63Field = cmp.find("lens63");
        var vlens63 = lens63Field.get("v.value");

        if (vexam63-vexam61>=vexam62*1) 
           vexam4=vexam62;
        else 
           vexam4=vexam63-vexam61;
        if (vexam4*1==0) vexam5=0;
        else {if (vexam4*1.5>=vexam63-vexam61) 
           vexam5=vexam63-vexam61;
        else 
            vexam5=vexam4*1.5;} 
        if (vexam4==0) vexam6=0;
        else {if (vexam4*2>=vexam63-vexam61) 
           vexam6=vexam63-vexam61;
        else 
            vexam6=vexam4*2;}

        if (vlens63-vlens61>=vlens62*1) 
           vlens4=vlens62;
        else 
           vlens4=vlens63-vlens61;
        if (vlens4*1==0) vlens5=0;
        else {if (vlens4*1.5>=vlens63-vlens61) 
           vlens5=vlens63-vlens61;
        else 
            vlens5=vlens4*1.5;} 
        if (vlens4==0) vlens6=0;
        else {if (vlens4*2>=vlens63-vlens61) 
           vlens6=vlens63-vlens61;
        else 
            vlens6=vlens4*2;}    
        cmp.set("v.exam4", vexam4);
        cmp.set("v.exam5", vexam5);
        cmp.set("v.exam6", vexam6);
        cmp.set("v.lens4", vlens4);
        cmp.set("v.lens5", vlens5);
        cmp.set("v.lens6", vlens6);

        if (vexam4<0) vexam4=0;
        if (vlens4<0) vlens4=0;
        if (vexam5<0) vexam5=0;
        if (vlens5<0) vlens5=0;
        if (vexam6<0) vexam6=0;
        if (vlens6<0) vlens6=0;
        cmp.set("v.total4", vexam4*1+vlens4*1); 
        cmp.set("v.total5", vexam5*1+vlens5*1); 
        cmp.set("v.total6", vexam6*1+vlens6*1);
        cmp.set("v.tab","6");
    },
    
copytocase_helper : function(cmp, vtab, voption) {
        var vlabel, vtotal, vexam, vlens, vframe, vother;
        if (voption=="1") {         	            
                vlabel="First Offer";
                vexam = cmp.get("v.exam4");
                vlens = cmp.get("v.lens4");
                vframe = cmp.get("v.frame4");
                vother = cmp.get("v.other4"); 
                vtotal = cmp.get("v.total4");
        }	
        else {
            if(voption=="2") {		
                vlabel="Second Offer";
                vexam = cmp.get("v.exam5");
                vlens = cmp.get("v.lens5");
                vframe = cmp.get("v.frame5");
                vother = cmp.get("v.other5"); 
                vtotal = cmp.get("v.total5");
            }
            else {
                vlabel="Final Offer";
                vexam = cmp.get("v.exam6");
                vlens = cmp.get("v.lens6");
                vframe = cmp.get("v.frame6");
                vother = cmp.get("v.other6"); 
                vtotal = cmp.get("v.total6");
            }
        }        
        var action = cmp.get("c.getcopytocase");
        action.setParams({
            "tab": vtab,
            "label": vlabel,
            "value": vtotal,
            "exam": vexam,
            "lens": vlens,
            "frame": vframe,
            "other": vother,
            "recordId": cmp.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Alert the user with the value returned 
                $A.get('e.force:refreshView').fire();
                alert('Calculator Results Copied.');
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
 
    }
})