/**
 * @description       : When Application Stage is changed, fires a platform event.
 * @author            : Roman Dzhus
 * @last modified on  : 09-12-2024
 * @last modified by  : Roman Dzhus
**/
public with sharing class ApplicationStageChangeEvent {

    public static void publishApplicationEvent(List<Application__c> applications, Map<Id, Application__c> oldMap) {

        final Set<Id> validApplicationIds = new Set<Id>();
        for (Application__c application : applications) {
            if (application.Application_Stage__c == oldMap.get(application.Id)?.Application_Stage__c) {
                continue;
            }

            if (application.Application_Stage__c != 'Employed/Hired') {
                continue;
            }
            validApplicationIds.add(application.Id);
        }

        if (validApplicationIds.isEmpty()) {
            return;
        }

        final List<Application_Stage_Change__e> eventsToPublish = new List<Application_Stage_Change__e>();
        for (Application__c application : [SELECT Id, Application_Stage__c, Candidate__r.Full_Name__c, Job_Requisition__r.Job_Title__c, Account__r.Name FROM Application__c WHERE Id IN :validApplicationIds]) {
            eventsToPublish.add(new Application_Stage_Change__e(
                    Application_Stage__c = application.Application_Stage__c,
                    Candidate_Full_Name__c = application.Candidate__r.Full_Name__c,
                    Job_Requisition_Title__c = application.Job_Requisition__r.Job_Title__c,
                    Account_Name__c = application.Account__r.Name
            ));
        }
        System.debug('eventsToPublish: ' + eventsToPublish);
        EventBus.publish(eventsToPublish);
    }
}
