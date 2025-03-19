global inherited sharing class CaseHoldingEmailHandler {
    @InvocableMethod(label='Send Holding Email' description='Sends a holding email when a case is opened.')
    public static void sendHoldingEmail(List<Id> caseIds) {
        if (caseIds == null || caseIds.isEmpty()) {
            return;
        }

        List<Case> caseList = [SELECT Id, ContactEmail FROM Case WHERE Id IN :caseIds];
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for (Case c : caseList) {
            if (c.ContactEmail != null) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new List<String>{c.ContactEmail});
                email.setSubject('We Have Received Your Case');
                email.setPlainTextBody('Thank you for contacting us. We have received your case and are working on it. We will keep you updated with any progress.');
                emails.add(email);
            }
        }

        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
    }
}