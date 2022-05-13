trigger CreateContactFormCase on Case (before insert) {
    for (Case caseTriggered : Trigger.new) {
        if (caseTriggered.Origin == 'Email') {
            CreateContactFromCaseHelper.createContact(Trigger.new);
        }
    }
}