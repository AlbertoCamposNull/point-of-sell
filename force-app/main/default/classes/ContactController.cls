public with sharing class ContactController {
    public ContactController() {}
    @AuraEnabled(cacheable=true)
    public static List<Contact> getCustomers(){
        ID customerTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
		return [SELECT Id, FirstName, LastName, Phone FROM Contact WHERE RecordTypeId = :customerTypeId];
    }

}