public with sharing class ItemController {
    public ItemController() {}

    @AuraEnabled(cacheable=true)
    public static List<Item__c> getItems(){
        return [SELECT Id, Name, Image_URL__c, Price__c, SKU__c, Supplier__c, Total__c, VAT__c
                FROM Item__c WITH SECURITY_ENFORCED];
    }

    @AuraEnabled(cacheable=true)
    public static List<Item__c> getItem(String itemId){
        return [SELECT Id, Name, Image_URL__c, Price__c, SKU__c, Supplier__c, Total__c, VAT__c
                FROM Item__c WHERE Id = :itemId WITH SECURITY_ENFORCED];
    }
}
