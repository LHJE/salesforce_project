public class utilities {
    public static void send_email(string recipient, string subject, string body){
    	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {recipient});
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        Messaging.SingleEmailMessage[] messages = new Messaging.SingleEmailMessage[] {mail};
     	Messaging.sendEmail(messages);
    }

    public static httpresponse api_call(string method, string endpoint, map<string, string> headers, string body) {
        httprequest request = new httprequest();
        request.setMethod(method);
        request.setEndpoint(endpoint);
        request.setBody(body);

        if (headers != null) { 
            for(string key : headers.keyset()) {
                request.setHeader(key, headers.get(key));
            }
        }

        return new http().send(request);
    }
}