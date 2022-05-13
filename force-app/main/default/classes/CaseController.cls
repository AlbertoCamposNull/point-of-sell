public with sharing class CaseController {
    public CaseController() {}

    @AuraEnabled
    public static String addCase(String json){
		CaseClassHelper obj = CaseClassHelper.parse(json);
        ID customerId;
        Contact customer = new Contact();
        List<Contact> customers = new List<Contact>();
        customers = [SELECT Id, FirstName, LastName, Phone 
                     FROM Contact 
                     WHERE FirstName = :obj.firstName AND LastName = :obj.lastName AND Email = :obj.email];
        if(customers.size() < 1){
            customer.FirstName = obj.firstName;
            customer.LastName = obj.lastName;
            customer.Phone = obj.phone;
            customer.Email = obj.email;
            customer.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            try{
            	insert customer;
                customerId = customer.Id;
        	} catch(DmlException e){
            	System.debug('Exception: ' + e.getMessage());
            	return 'error customer';
            }
            
        } else {
            try{
                customer = customers[0];
                customerId = customer.Id;
            } catch(Exception e){
                System.debug('Exception: ' + e.getMessage());
            }
        }
        
        Case newCase = new Case();
        newCase.Status = 'New';
        newCase.Origin = 'Web';
        newCase.Priority = 'Low';
        newCase.Subject = obj.subject;
        newCase.Description = obj.description;
        newCase.SKU__c = obj.SKU;
        newCase.Address__c = obj.country + ' ' + obj.city + ' ' + obj.province + ' ' + obj.street + ' ' + obj.postalCode;
        newCase.ContactId = customerId;
        try{
            insert newCase;
            Case caseObject = [SELECT CaseNumber FROM Case WHERE Id = :newCase.Id];
            return caseObject.CaseNumber;  
        } catch(DmlException e){
            System.debug('Exception: ' + e.getMessage() );
            return 'error case ' + e.getMessage();
        }
    }

}