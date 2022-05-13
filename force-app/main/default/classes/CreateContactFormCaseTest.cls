@isTest private class CreateContactFormCaseTest {
    @isTest static void createContactTriggerTest(){
        Case caseTest = new Case();
        caseTest.Status = 'New';
        caseTest.Origin = 'Email';
        caseTest.Subject = 'Test';
        caseTest.Description = 'This is a test';
        caseTest.Address__c = 'Av Mariano matamoros, 56172, Mor. Mexico';

        insert caseTest;
    }
    @isTest static void createContactTest(){
        List<Case> casesList = [SELECT Id, Subject, Description FROM Case];

        CreateContactFromCaseHelper.createContact(casesList);
    }
}
