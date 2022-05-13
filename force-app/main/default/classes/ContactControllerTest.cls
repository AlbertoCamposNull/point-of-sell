@isTest private class ContactControllerTest {
    @isTest static void getCustomersTest(){
        List<Contact> contactList = ContactController.getCustomers();
        ID customerTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
		List<Contact> contactListTest = [SELECT Id, FirstName, LastName, Phone FROM Contact WHERE RecordTypeId = :customerTypeId];
        System.assertEquals(contactListTest, contactList, 'Same');
    }
}
