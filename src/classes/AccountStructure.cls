/**  Copyright (c) 2008, Matthew Friend, Sales Engineering, Salesforce.com Inc.
*  All rights reserved.
*
*  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
*  Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer. 
*  Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
*  Neither the name of the salesforce.com nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission. 
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
*  INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
*  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
*  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
*  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
*  EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

/**
* To adapt this to anouther Object simply search for "Change" to go to the places 
* where the sObject and query must be changed
*/
public with sharing class AccountStructure {
    
    //Declare variables
    public String currentId;
    public List < ObjectStructureMap > asm;
    public Map < String, ObjectStructureMap > masm;
    public List < Integer > maxLevel;
    
    /**
* Contructor
*/
    public AccountStructure(ApexPages.StandardController myController) {
        this.asm = new List < ObjectStructureMap > {};
            this.masm = new Map < String, ObjectStructureMap > {};
                this.maxLevel = new List < Integer > {};
                    }
    
    /**
* Allow page to set the current ID
*/
    public void setcurrentId(String cid) {
        currentId = cid;
    }
    
    /**
* Return ObjectStructureMap to page
* @return asm
*/
    public List < ObjectStructureMap > getObjectStructure() {
        
        asm.clear();
        if (currentId == null) {
            currentId = System.currentPageReference().getParameters().get('id');
        }
        
        System.assertNotEquals(currentId, null, 'sObject ID must be provided');
        asm = formatObjectStructure(CurrentId);
        
        List<ObjectStructureMap> noAddNumberList=new List<ObjectStructureMap>();
        List<ObjectStructureMap> finalList=new List<ObjectStructureMap>();
        List<ObjectStructureMap> tempList=new List<ObjectStructureMap>();
        
        
        List<integer> sortList=new List<integer>();
        for(ObjectStructureMap ob: asm){
            if(ob.nodetype!='start'){
                string temp='';
                if(ob.ShippingStreet!=null){
                    temp=ob.ShippingStreet.split(' ')[0].replaceAll('\\D','');
                    if(temp.length()>0)sortList.add(integer.valueOf(temp));
                    else noAddNumberList.add(ob);
                }
                else noAddNumberList.add(ob);
                tempList.add(ob);
            }else finalList.add(ob);
            
        }
        sortList.sort();
        set<string> accIdSet=new set<string>();
        for(integer i:sortList){
            for(ObjectStructureMap ob:tempList){
                
                if(ob.shippingstreet!=null){
                    string temp=ob.ShippingStreet.split(' ')[0].replaceAll('\\D','');
                    if(temp==string.valueof(i)){
                        
                        if(!accIdSet.contains(ob.account.id)){
                            if(ob.nodetype=='end')ob.nodetype='child';
                            finalList.add(ob);accIdSet.add(ob.account.id);
                            break;
                        }
                        
                    }
                }
            }
        }
        
        
        finalList.addall(noAddNumberList);
        
        //finalList[0].nodeType = 'start';
        finalList[finalList.size()-1].nodetype='end';
        //
        
        if(finalList.size()<=2)return asm;
        
        for(ObjectStructureMap ob:asm)system.debug('-obob---'+ob);
        
        
        return finalList;
    }
    
    /**
* Query Account from top down to build the ObjectStructureMap
* @param currentId
* @return asm
*/
    public ObjectStructureMap[] formatObjectStructure(String currentId) {
        List < ObjectStructureMap > asm = new List < ObjectStructureMap > {};
            masm.clear();
        //Change below
        List < Account > al = new List < Account > {};
            List < ID > currentParent = new List < ID > {};
                Map < ID, String > nodeList = new Map < ID, String > {};
                    List < String > nodeSortList = new List < String > {};
                        List < Boolean > levelFlag = new List < Boolean > {};
                            List < Boolean > closeFlag = new List < Boolean > {};
                                String nodeId = '0';
        String nodeType = 'child';
        Integer level = 0;
        Boolean endOfStructure = false;
        Boolean isPAException = false;
        Boolean isBAException = false;
        List < Account > childAccounts = new List < Account > {};
            List < Contact > contactList = new List < Contact > ();
        List < Account > childAccountsLE = new List < Account > ();
        List < Contact > childContacts = new List < Contact > ();
        List < Contact > ccContacts = new List < Contact > ();
        List < Contact_Role__c > listContactRoles = new List < Contact_Role__c > ();
        Set < ID > acctSet = new Set < ID > ();
        Boolean flag = false;
        //Find highest level object in the structure
        currentParent.add(GetTopElement(currentId));
        //Loop though all children
        while (!endOfStructure) {
            if (level == 0) {
                al = [SELECT a.Type, a.Site, a.ParentId, a.OwnerId, a.Name, a.Industry, a.Id, a.tax_id__c, a.ShippingStreet, a.ShippingCity, a.ShippingState, a.ShippingPostalCode, a.Phone, a.Status__c, a.Vision_Care_Effective_Date__c, a.Vision_Care_End_Date__c, a.Vision_Care_Location_Exception__c, a.Vision_Care_Practice_Exception__c, a.RecordType.Name, a.IsBAException__c, a.IsPAException__c, a.VC__c, a.of_Contact_Roles__c FROM Account a WHERE a.id IN: CurrentParent ORDER BY a.Status__c, a.Name LIMIT 1000];
                for (Account acct1: al) {
                    acctSet.add(acct1.ID);
                }
                for (Account acct1: al) {
                    if (acct1.VC__c) {
                        if (acct1.RecordType.Name == 'Practice Account') {
                            if (acct1.Vision_Care_Practice_Exception__c != null) {
                                isPAException = true;
                                acct1.IsPAException__c = true;
                            }
                            childAccounts = [SELECT Id, IsBAException__c, IsPAException__c FROM Account WHERE ParentId = : acct1.ID AND ID IN(SELECT AccountID FROM Contact WHERE Contact_Exception__c = TRUE AND VC__c = TRUE) ORDER BY Id DESC];
                            childAccountsLE = [SELECT Vision_Care_Location_Exception__c FROM Account WHERE ParentId = : acct1.ID AND Vision_Care_Location_Exception__c != NULL AND VC__c = TRUE ORDER BY Vision_Care_Location_Exception__c DESC];
                            if (childAccounts.size() > 0) {
                                isPAException = true;
                                acct1.IsPAException__c = true;
                                isBAException = true;
                                acct1.IsBAException__c = true;
                            }
                            if (childAccountsLE.size() > 0) {
                                isPAException = true;
                                acct1.IsPAException__c = true;
                                isBAException = true;
                                acct1.IsBAException__c = true;
                            }
                            listContactRoles = [SELECT ID, Contact__c, Account__r.ID, Contact__r.ID, Contact__r.Contact_Exception__c, Contact__r.Vision_Care_Doctor_Exception__c, Vision_Care_Contact_Role_Exception__c FROM Contact_Role__c WHERE Account__r.ParentId = : acct1.ID AND(Contact__r.Vision_Care_Doctor_Exception__c != NULL OR Contact__r.Contact_Exception__c = TRUE)];
                            if (listContactRoles.size() > 0) {
                                isPAException = true;
                                acct1.IsPAException__c = true;
                                isBAException = true;
                                acct1.IsBAException__c = true;
                            }
                        } else if (acct1.RecordType.Name == 'Business Account') {
                            if (acct1.Vision_Care_Location_Exception__c != null) {
                                isPAException = true;
                                acct1.IsPAException__c = true;
                                isBAException = true;
                                acct1.IsBAException__c = true;
                            }
                            childContacts = [SELECT AccountID FROM Contact WHERE Contact_Exception__c = TRUE AND AccountID IN: acctSet AND VC__c = TRUE];
                            if (childContacts.size() > 0) {
                                acct1.IsBAException__c = true;
                                isBAException = true;
                                isPAException = true;
                                acct1.IsPAException__c = true;
                            }
                            listContactRoles = [SELECT ID, Contact__c, Account__r.ID, Contact__r.ID, Contact__r.Contact_Exception__c, Contact__r.Vision_Care_Doctor_Exception__c, Vision_Care_Contact_Role_Exception__c FROM Contact_Role__c WHERE Account__r.ID = : acct1.ID AND(Contact__r.Vision_Care_Doctor_Exception__c != NULL OR Contact__r.Contact_Exception__c = TRUE)];
                            if (listContactRoles.size() >= 1) { //Inspect contact roles at the account and see if their contacts have exceptions                               
                                for (Contact_Role__c c1: listContactRoles) {
                                    if (!flag) {
                                        if (c1.Contact__r.Vision_Care_Doctor_Exception__c != NULL || c1.Vision_Care_Contact_Role_Exception__c != NULL) {
                                            flag = true;
                                        }
                                    }
                                }
                                if (flag) {
                                    acct1.IsBAException__c = true;
                                    isBAException = true;
                                    acct1.IsPAException__c = true;
                                    isPAException = true;
                                } else {
                                    acct1.IsBAException__c = false;
                                    isBAException = false;
                                    acct1.IsPAException__c = false;
                                    isPAException = false;
                                }
                            }
                        }
                    }
                }
            } //end of level check                                  
            else {
                al = [SELECT a.Type, a.Site, a.ParentId, a.OwnerId, a.Name, a.Industry, a.Id, a.tax_id__c, a.ShippingStreet, a.ShippingCity, a.ShippingState, a.ShippingPostalCode, a.Phone, a.Status__c, a.Vision_Care_Effective_Date__c, a.Vision_Care_End_Date__c, a.Vision_Care_Location_Exception__c, a.Vision_Care_Practice_Exception__c, a.RecordType.Name, a.IsPAException__c, a.IsBAException__c, a.VC__c, a.of_Contact_Roles__c FROM Account a WHERE a.ParentID IN: CurrentParent ORDER BY a.Status__c, a.Name LIMIT 1000];
                for (Account acct1: al) {
                    acctSet.add(acct1.ID);
                }
                List<Contact_Role__c> contactrolesList= [SELECT ID, Contact__c, Account__r.ID, Contact__r.ID, Contact__r.Contact_Exception__c, Contact__r.Vision_Care_Doctor_Exception__c, Vision_Care_Contact_Role_Exception__c FROM Contact_Role__c WHERE Account__r.ID In :acctSet AND(Contact__r.Vision_Care_Doctor_Exception__c != NULL OR Contact__r.Contact_Exception__c = TRUE)];
                
                Map<id,List<Contact_Role__c>> accidConRoleMap=new Map<id,List<Contact_Role__c>> ();
                for(Contact_Role__c cr:contactrolesList){ accidConRoleMap.put(cr.Account__r.ID,new List<Contact_Role__c>{cr});
                                                        }

                childContacts = [SELECT AccountID FROM Contact WHERE Contact_Exception__c = TRUE AND AccountID IN: acctSet AND VC__c = TRUE];
                for (Account acct1: al) {
                    if (acct1.VC__c) {
                        if (acct1.RecordType.Name == 'Practice Account') {
                            if (acct1.Vision_Care_Practice_Exception__c != null) {
                                isPAException = true;
                                acct1.IsPAException__c = true;
                            }
                            childAccounts = [SELECT Id, IsBAException__c, IsPAException__c FROM Account WHERE ParentId = : acct1.ID AND ID IN(SELECT AccountID FROM Contact WHERE Contact_Exception__c = TRUE AND VC__c = TRUE) ORDER BY Id DESC];
                            childAccountsLE = [SELECT Vision_Care_Location_Exception__c FROM Account WHERE ParentId = : acct1.ID AND Vision_Care_Location_Exception__c != NULL AND VC__c = TRUE ORDER BY Vision_Care_Location_Exception__c DESC];
                            if (childAccounts.size() > 0) {
                                isPAException = true;
                                acct1.IsPAException__c = true;
                                isBAException = true;
                                acct1.IsBAException__c = true;
                            }
                            if (childAccountsLE.size() > 0) {
                                isPAException = true;
                                acct1.IsPAException__c = true;
                                isBAException = true;
                                acct1.IsBAException__c = true;
                            }
                            if(accidConRoleMap.containskey(acct1.id))listContactRoles=accidConRoleMap.get(acct1.id);
                            //listContactRoles = [SELECT ID, Contact__c, Account__r.ID, Contact__r.ID, Contact__r.Contact_Exception__c, Contact__r.Vision_Care_Doctor_Exception__c FROM Contact_Role__c WHERE Account__r.ParentId = : acct1.ID AND(Contact__r.Vision_Care_Doctor_Exception__c != NULL OR Contact__r.Contact_Exception__c = TRUE)];
                            if (listContactRoles.size() > 0) {
                                isPAException = true;
                                acct1.IsPAException__c = true;
                                isBAException = true;
                                acct1.IsBAException__c = true;
                            }
                        } else if (acct1.RecordType.Name == 'Business Account') {
                            if (acct1.Vision_Care_Location_Exception__c != null) {
                                isPAException = true;
                                acct1.IsPAException__c = true;
                                isBAException = true;
                                acct1.IsBAException__c = true;
                            }
                            if (childContacts.size() > 0) {
                                acct1.IsBAException__c = true;
                                isBAException = true;
                                isPAException = true;
                                acct1.IsPAException__c = true;
                            }
                            if(accidConRoleMap.containskey(acct1.id))listContactRoles=accidConRoleMap.get(acct1.id);
                            //listContactRoles = [SELECT ID, Contact__c, Account__r.ID, Contact__r.ID, Contact__r.Contact_Exception__c, Contact__r.Vision_Care_Doctor_Exception__c, Vision_Care_Contact_Role_Exception__c FROM Contact_Role__c WHERE Account__r.ID = : acct1.ID AND(Contact__r.Vision_Care_Doctor_Exception__c != NULL OR Contact__r.Contact_Exception__c = TRUE)];
                            if (listContactRoles.size() >= 1) { //Inspect contact roles at the account and see if their contacts have exceptions                               
                                for (Contact_Role__c c1: listContactRoles) {
                                    if (!flag) {
                                        if (c1.Contact__r.Vision_Care_Doctor_Exception__c != NULL || c1.Vision_Care_Contact_Role_Exception__c != NULL) {
                                            flag = true;
                                        }
                                    }
                                }
                                if (flag) {
                                    acct1.IsBAException__c = true;
                                    isBAException = true;
                                    acct1.IsPAException__c = true;
                                    isPAException = true;
                                } else {
                                    acct1.IsBAException__c = false;
                                    isBAException = false;
                                    acct1.IsPAException__c = false;
                                    isPAException = false;
                                }
                            }
                        }
                    }
                }
            }
            if (al.size() == 0) {
                endOfStructure = true;
            } else {
                currentParent.clear();
                for (Integer i = 0; i < al.size(); i++) {
                    //Change below
                    Account a = al[i];
                    nodeId = (level > 0) ? NodeList.get(a.ParentId) + '.' + String.valueOf(i) : String.valueOf(i);
                    masm.put(NodeID, new ObjectStructureMap(nodeID, levelFlag, closeFlag, nodeType, false, false, a, a.IsPAException__c, a.IsBAException__c));
                    currentParent.add(a.id);
                    nodeList.put(a.id, nodeId);
                    nodeSortList.add(nodeId);
                }
                maxLevel.add(level);
                level++;
            }
        }
        
        //Account structure must now be formatted
        //NodeSortList.sort();
        for (Integer i = 0; i < NodeSortList.size(); i++) {
            List < String > pnl = new List < String > {};
                List < String > cnl = new List < String > {};
                    List < String > nnl = new List < String > {};
                        
                        if (i > 0) {
                            String pn = NodeSortList[i - 1];
                            pnl = pn.split('\\.', -1);
                        }
            
            String cn = NodeSortList[i];
            cnl = cn.split('\\.', -1);
            
            if (i < NodeSortList.size() - 1) {
                String nn = NodeSortList[i + 1];
                nnl = nn.split('\\.', -1);
            }
            
            ObjectStructureMap tasm = masm.get(cn);
            if (cnl.size() < nnl.size()) {
                //Parent
                tasm.nodeType = (isLastNode(cnl)) ? 'parent_end' : 'parent';
            } else if (cnl.size() > nnl.size()) {
                tasm.nodeType = 'child_end';
                tasm.closeFlag = setcloseFlag(cnl, nnl, tasm.nodeType);
            } else {
                tasm.nodeType = 'child';
            }
            
            tasm.levelFlag = setlevelFlag(cnl, tasm.nodeType);
            
            //Change below
            if (tasm.account.id == currentId) {
                tasm.currentNode = true;
            }
            asm.add(tasm);
        }
        
        asm[0].nodeType = 'start';
        asm[asm.size() - 1].nodeType = 'end';
        
        return asm;
    }
    
    /**
* Determin parent elements relationship to current element
* @return flagList
*/
    public List < Boolean > setlevelFlag(List < String > nodeElements, String nodeType) {
        
        List < Boolean > flagList = new List < Boolean > {};
            String searchNode = '';
        String workNode = '';
        Integer cn = 0;
        
        for (Integer i = 0; i < nodeElements.size() - 1; i++) {
            cn = Integer.valueOf(nodeElements[i]);
            cn++;
            searchNode = workNode + String.valueOf(cn);
            workNode = workNode + nodeElements[i] + '.';
            if (masm.containsKey(searchNode)) {
                flagList.add(true);
            } else {
                flagList.add(false);
            }
        }
        return flagList;
    }
    
    /**
* Determin if the element is a closing element
* @return flagList
*/
    public List < Boolean > setcloseFlag(List < String > cnl, List < String > nnl, String nodeType) {
        
        List < Boolean > flagList = new List < Boolean > {};
            String searchNode = '';
        String workNode = '';
        Integer cn = 0;
        
        for (Integer i = nnl.size(); i < cnl.size(); i++) {
            flagList.add(true);
        }
        return flagList;
    }
    
    /**
* Determin if Element is the bottom node  
* @return Boolean
*/
    public Boolean isLastNode(List < String > nodeElements) {
        
        String searchNode = '';
        Integer cn = 0;
        
        for (Integer i = 0; i < nodeElements.size(); i++) {
            if (i == nodeElements.size() - 1) {
                cn = Integer.valueOf(nodeElements[i]);
                cn++;
                searchNode = searchNode + String.valueOf(cn);
            } else {
                searchNode = searchNode + nodeElements[i] + '.';
            }
        }
        if (masm.containsKey(searchNode)) {
            return false;
        } else {
            return true;
        }
    }
    
    /**
* Find the tom most element in Heirarchy  
* @return objId
*/
    public String GetTopElement(String objId) {
        
        Boolean top = false;
        while (!top) {
            //Change below
            Account a = [Select a.Id, a.ParentId From Account a where a.Id = : objId limit 1];
            
            if (a.ParentID != null) {
                objId = a.ParentID;
            } else {
                top = true;
            }
        }
        return objId;
    }
    
    /**
* Wrapper class
*/
    public with sharing class ObjectStructureMap {
        
        public String nodeId;
        public Boolean[] levelFlag = new Boolean[] {};
            public Boolean[] closeFlag = new Boolean[] {};
                public String nodeType;
        public Boolean currentNode;
        public Boolean isPAException;
        public Boolean isBAException;
        
        /**
* @Change this to your sObject
*/
        public Account account;
        
        public String getnodeId() {
            return nodeId;
        }
        public Boolean[] getlevelFlag() {
            return levelFlag;
        }
        public Boolean[] getcloseFlag() {
            return closeFlag;
        }
        public String getnodeType() {
            return nodeType;
        }
        public Boolean getcurrentNode() {
            return currentNode;
        }
        public Boolean getisPAException() {
            return isPAException;
        }
        public Boolean getisBAException() {
            return isBAException;
        }
        
        /**
* @Change this to your sObject
*/
        public Account getaccount() {
            return account;
        }
        
        public void setnodeId(String n) {
            this.nodeId = n;
        }
        public void setlevelFlag(Boolean l) {
            this.levelFlag.add(l);
        }
        public void setlcloseFlag(Boolean l) {
            this.closeFlag.add(l);
        }
        public void setnodeType(String nt) {
            this.nodeType = nt;
        }
        public void setcurrentNode(Boolean cn) {
            this.currentNode = cn;
        }
        public void setisPAException(Boolean pae) {
            this.isPAException = pae;
        }
        public void setisBAException(Boolean bae) {
            this.isBAException = bae;
        }
        
        /**
* @Change this to your sObject
*/
        public void setaccount(Account a) {
            this.account = a;
        }
        public string shippingStreet{get;set;}
        
        /**
* @Change the parameters to your sObject
*/
        public ObjectStructureMap(String nodeId, Boolean[] levelFlag, Boolean[] closeFlag, String nodeType, Boolean lastNode, Boolean currentNode, Account a, Boolean isPAException, Boolean isBAException) {
            
            this.nodeId = nodeId;
            this.levelFlag = levelFlag;  
            this.closeFlag = closeFlag;
            this.nodeType = nodeType;
            this.currentNode = currentNode;
            this.isPAException = isPAException;
            this.isBAException = isBAException;
            this.shippingStreet=a.ShippingStreet;
            //Change this to your sObject  
            this.account = a;
            a.IsPAException__c = isPAException;
            a.IsBAException__c = isBAException;
        }
    }
}