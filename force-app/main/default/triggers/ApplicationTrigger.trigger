trigger ApplicationTrigger on Application__c (after insert, after update ) {
    if (Trigger.isAfter && Trigger.isInsert) {
        ApplicationTriggerHandler.handleApplicationSharing(Trigger.new);
    }
    if (Trigger.isAfter && Trigger.isUpdate) {
        ApplicationStageChangeEvent.publishApplicationEvent(Trigger.new, Trigger.oldMap);
    }
}