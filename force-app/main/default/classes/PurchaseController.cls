public with sharing class PurchaseController {
    public PurchaseController() {}
    @AuraEnabled
    public static boolean addPurchase(String itemId, String customerId){
        Purchase__c newPurchase = new Purchase__c();
        newPurchase.Date__c = DateTime.now();
        newPurchase.Item__c = itemId;
        newPurchase.Customer__c = customerId;
        try{
            insert newPurchase;
            return true;  
        } catch(DmlException e){
            System.debug('Exception: ' + e.getMessage() );
            return false;
        }
    }
}
