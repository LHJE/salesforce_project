public class utilities {
    public static void send_email(string recipient, string subject, string body){
    	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {recipient});
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        Messaging.SingleEmailMessage[] messages = new Messaging.SingleEmailMessage[] {mail};
     	Messaging.sendEmail(messages);
    }
}