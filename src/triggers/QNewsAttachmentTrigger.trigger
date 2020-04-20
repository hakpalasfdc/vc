trigger QNewsAttachmentTrigger on QNews__c (after insert, after update) {
        QNewsAttachmentUtility obj = new QNewsAttachmentUtility();
        obj.saveAttachmentToQNews(trigger.new);
}