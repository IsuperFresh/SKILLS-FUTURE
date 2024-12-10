@IsTest
private class ApplicationStageChangeEventTest {

    @IsTest
    static void testPublishApplicationEvent() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testCandidate = new Contact(FirstName = 'John', LastName = 'Doe', AccountId = testAccount.Id);
        insert testCandidate;

        Job_Requisition__c testJobRequisition = new Job_Requisition__c(Job_Title__c = 'Software Engineer', Account__c = testAccount.Id);
        insert testJobRequisition;

        Application__c testApplication = new Application__c(
                Candidate__c = testCandidate.Id,
                Job_Requisition__c = testJobRequisition.Id,
                Account__c = testAccount.Id,
                Application_Stage__c = 'New'
        );
        insert testApplication;

        Application__c updatedApplication = new Application__c(
                Id = testApplication.Id,
                Application_Stage__c = 'Employed/Hired'
        );
        Map<Id, Application__c> oldMap = new Map<Id, Application__c>{
                testApplication.Id => testApplication
        };

        Test.startTest();
        ApplicationStageChangeEvent.publishApplicationEvent(
                new List<Application__c>{
                        updatedApplication
                },
                oldMap
        );
        Test.stopTest();
    }
}
