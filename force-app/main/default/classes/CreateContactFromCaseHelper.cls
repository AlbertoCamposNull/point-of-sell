public class CreateContactFromCaseHelper {
    public static void createContact(List<Case> triggerNew){
        List<String> caseEmails = new List<String>();
        for (Case caseTriggered : triggerNew){
            if (caseTriggered.ContactId == null && caseTriggered.SuppliedEmail == '' || caseTriggered.SuppliedEmail == null) {
                caseEmails.add(caseTriggered.SuppliedEmail);
            }
        }

        List<Contact> contactsList = [SELECT Id, Email 
                                        FROM Contact 
                                        WHERE Email in : caseEmails];

        //List does not support contains
        Set<String> existingEmails = new Set<String>();
        for (Contact contact : contactsList) {
            existingEmails.add(contact.Email);
        }

        //To use '.put'
        Map<String, Contact> emailToContactMap = new Map<String, Contact>();
        List<Case> casesToUpdate = new List<Case>();

        for (Case caseTriggered : triggerNew) {
            if (existingEmails.contains(caseTriggered.SuppliedEmail)) {
                Contact existingContact = [SELECT Id, Email FROM Contact WHERE Email = :caseTriggered.SuppliedEmail];
                caseTriggered.ContactId = existingContact.Id;
            }
        }

        for (Case caseTriggered : triggerNew) {
            if (caseTriggered.ContactId == null && 
                caseTriggered.SuppliedName != null && 
                caseTriggered.SuppliedEmail != null &&  
                caseTriggered.SuppliedName != '' && 
                !caseTriggered.SuppliedName.contains('@') && 
                caseTriggered.SuppliedEmail != '') {
                String[] emailHeader = caseTriggered.SuppliedName.split(' ',2);
                if (emailHeader.size() == 2) {
                    Contact newContact = new Contact();
                    newContact.FirstName = emailHeader[0];
                    newContact.LastName = emailHeader[1];
                    newContact.Email = caseTriggered.SuppliedEmail;
                    newContact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
                    emailToContactMap.put(caseTriggered.SuppliedEmail, newContact);
                    casesToUpdate.add(caseTriggered);
                }
            }
        }

        List<Contact> newContacts = emailToContactMap.values();
        try {
            insert newContacts;
        } catch (DmlException e) {
            System.debug('Exception: ' + e.getMessage());
        }

        for (Case updateCase : casesToUpdate) {
            Contact newContact = emailToContactMap.get(updateCase.SuppliedEmail);

            updateCase.ContactId = newContact.Id;
        }
        
    }
}