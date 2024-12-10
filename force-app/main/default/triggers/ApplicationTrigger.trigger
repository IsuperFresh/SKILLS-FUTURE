/**
 * Created by r.dzhus on 09.12.2024.
 */

trigger ApplicationTrigger on Application__c (after update) {

    if (Trigger.isAfter && Trigger.isUpdate) {
        ApplicationStageChangeEvent.publishApplicationEvent(Trigger.new, Trigger.oldMap);
    }
}