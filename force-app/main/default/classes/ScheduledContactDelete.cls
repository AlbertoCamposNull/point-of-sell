global class ScheduledContactDelete implements Schedulable {
    global void execute(SchedulableContext sc) {
        ID customerRecordType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        List<Contact> contactsList = [SELECT Id, FirstName, LastName, CreatedDate
                                      FROM Contact 
                                      WHERE RecordTypeId = :customerRecordType];
        Set<Purchase__c> purchaseSet = new Set<Purchase__c>();
        Set<Contact> contactSet = new Set<Contact>();
        Set<Contact> noPurchasesContactSet = new Set<Contact>();
        for (Contact contact : contactsList) {
            if (!contactSet.contains(contact) && !noPurchasesContactSet.contains(contact)) {
                Purchase__c purchase;
                try {
                    purchase = [SELECT Id, Date__c, Customer__r.FirstName, Customer__r.LastName, Customer__r.Id 
                                            FROM Purchase__c 
                                            WHERE Customer__r.Id = :contact.Id
                                            ORDER BY Date__c 
                                            DESC LIMIT 1];
                } catch (Exception ex) {
                    purchase = null;
                }

                if (purchase != null) {
                    purchaseSet.add(purchase);
                    contactSet.add(contact);
                } else {
                    noPurchasesContactSet.add(contact);
                }
               
                
            }
        }

        //System.debug('ContactSet' + contactSet);
        //System.debug('NoPurchasesContactSet' + noPurchasesContactSet);
        //System.debug('PurchaseSet' + purchaseSet);

        for (Purchase__c purchase : purchaseSet) {
            if (purchase.Date__c + 3 < Datetime.now()) {
                Contact contact = [SELECT Id, FirstName, LastName 
                                   FROM Contact 
                                   WHERE Id = :purchase.Customer__c];
                 try {
                    delete [SELECT Id FROM Case WHERE ContactId = :purchase.Customer__c];
                    Account acc;
                    try {
                        acc = [SELECT Id, Primary_Contact__c FROM Account WHERE Primary_Contact__c = :purchase.Customer__c];
                        acc.Primary_Contact__c = null;
                        update acc;
                        delete acc;
                    } catch (Exception e) {
                        acc = null;
                    }
                    delete contact;
                    //System.debug('Usuario Eliminado por no compras en 3 dias: ' + contact);
                } catch (Exception ex) {
                    System.debug(ex.getMessage());
                }
            }
        }

        for (Contact contact : noPurchasesContactSet) {
            if (contact.CreatedDate + 3 < Datetime.now()) {
                try {
                    delete [SELECT Id FROM Case WHERE ContactId = :contact.Id];
                    Account acc;
                    try {
                        acc = [SELECT Id, Primary_Contact__c FROM Account WHERE Primary_Contact__c = :contact.Id];
                        acc.Primary_Contact__c = null;
                        update acc;
                        delete acc;
                    } catch (Exception e) {
                        acc = null;
                    }
                    delete contact;
                } catch (Exception ex) {
                    System.debug(ex.getMessage());
                }
                //System.debug('Usuario con no compras Eliminado por no hacer nada en 3 dias:' + contact);
            }
        }

    }            
}