@isTest private class ItemControllerTest {
    @isTest static void getItemsTest(){
        List<Item__c> itemsList = ItemController.getItems();
        List<Item__c> itemsListTest = [SELECT Id, Name, Image_URL__c, Price__c, SKU__c, Supplier__c, Total__c, VAT__c FROM Item__c];
        System.assertEquals(itemsListTest, itemsList, 'Same');
    }

    @isTest static void getItemTest(){
        Item__c itemTest = new Item__c();
        itemTest.Name = 'Watch';
        itemTest.Image_URL__c = 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1099&q=80';
        itemTest.Price__c = 99;
        itemTest.SKU__c = 'HY6SJI876A';
        itemTest.VAT__c = .16;

        insert itemTest;

        List<Item__c> itemsList = ItemController.getItem(itemTest.Id);
        List<Item__c> itemsListTest = [SELECT Id, Name, Image_URL__c, Price__c, SKU__c, Supplier__c, Total__c, VAT__c FROM Item__c WHERE Id = :itemTest.Id];
        System.assertEquals(itemsListTest, itemsList, 'Same');
    }
}
