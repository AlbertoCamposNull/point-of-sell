@isTest 
private class PurchaseControllerTest {
    @isTest static void addPurchaseTest(){
        Item__c itemTest = new Item__c();
        itemTest.Name = 'Watch';
        itemTest.Image_URL__c = 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1099&q=80';
        itemTest.Price__c = 99;
        itemTest.SKU__c = 'HY6SJI876A';
        itemTest.VAT__c = .16;
        insert itemTest;

        ID customerTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Contact contactTest = new Contact();
        contactTest.FirstName = 'Alberto';
        contactTest.LastName = 'Campos';
        contactTest.Phone = '7771585683';
        contactTest.Email = 'sr.albertocampos@gmail.com';
        insert contactTest;
        
        PurchaseController.addPurchase(itemTest.Id, contactTest.Id);



    }
}
