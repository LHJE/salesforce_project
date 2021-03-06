public with sharing class BandMerch {
   public Item[] items {get; private set;}
   public datetime now {get{return datetime.now();}}
   public string state {get; private set;}
   public string ccNumber {get; set;}
   public string expMonth {get; set;}
   public string expYear {get; set;}
   public string ccv {get; set;}
   public string email {get; set;}
   public string firstName {get; set;}
   public string lastName {get; set;}
   public string street {get; set;}
   public string zipcode {get; set;}
   public map<string, string> credentials;
   public string error {get; private set;}
   public class Item {
       public Merch__c merch{get; private set;}
       public integer quantity {get{return Math.max(0, quantity);} set;}
       public integer addedQuantity {get; set;}
       public decimal subtotal {get{return quantity * merch.price__c;}}
       public Item(Merch__c merch) {
           this.merch = merch;
           this.quantity = 0;
       }
       public void add() {
           quantity += addedQuantity;
       }
   }
   public BandMerch() {
       items = new Item[] {};
       state = 'initial state';
       for ( Merch__c merch : [select  id, name, description__c, price__c from Merch__c]) {
           items.add(new Item(merch));
       }
   }
   public decimal getTotal() {
       decimal total = 0;
       for (Item item : items ) {
           total += item.subtotal;
       }
       return total;
   }
   public void updateQuantity() {
       // placeholder method for visualforce action
   }
   public void displayCheckout() {
       state = 'checkout';
   }
   public void fetchCredentials() {
       api_credential__mdt record = [SELECT key__c, secret__c FROM api_credential__mdt WHERE developername = 'Authorizedotnet' LIMIT 1];
       credentials = new map<string, string>{'key' => record.key__c, 'secret' => record.secret__c};
   }
   public string debug {get; private set;}
   public void chargeCard() {
       // debug = requestBody();
       HttpRequest request = new HttpRequest();
       request.setEndpoint('https://apitest.authorize.net/xml/v1/request.api');
       request.setMethod('POST');
       // request.setHeader('');
       request.setBody(requestBody());
       HttpResponse httpResponse = new http().send(request);
       // debug = httpResponse.getBody();
       try {
           AuthorizeDotNet.Response response = (AuthorizeDotNet.Response)JSON.deserialize(httpResponse.getBody().subString(1), AuthorizeDotNet.Response.class);
           debug = string.valueOf(response);
           handleResponse(response);
       } catch(exception e) {
           error = 'Sorry something went wrong!';
       } 
   }
   private void handleResponse(AuthorizeDotNet.Response response) {
       error = null;
       if (response.messages.resultCode == 'Error') {
           if (response.transactionResponse?.errors?.get(0)?.errorText != null)  {
               error = response.transactionResponse.errors[0].errorText;
           } else {
               error = 'Sorry something went wrong!';
           }
       } else {
           recordOrder(response);
           state = 'complete';
       }
   }
   private void recordOrder(AuthorizeDotNet.Response response) {
       Merch_Order__c merchOrder = new Merch_Order__c(address__c = street + ', ' + zipcode, Customer_Name__c = firstName + ' ' + lastName);
       insert merchOrder;
       Merch_Order_Item__c[] merchOrderItems = new merch_Order_Item__c[]{};
       for (Item item : items) {
           if (item.quantity > 0) {
               merchOrderItems.add(new Merch_Order_Item__c(Merch_Order__c = merchOrder.id, Merch__c = item.merch.id, Price__c = item.merch.price__c, Quantity__c = item.quantity));
           }
       }
       insert merchOrderItems;
   }
   // public class createTransactionRequest {
   //     public transactionRequest transactionRequest;
   //     public createTransactionRequest() {
   //         transactionRequest = new transactionRequest();
   //     }
   // }
   // public class transactionRequest {
   //     public payment payment;
   //     public transactionRequest() {
   //         payment = new payment();
   //     }
   // }
   // public class payment {
   //     public creditCard creditCard;
   //     public payment() {
   //         creditCard = new creditCard();
   //     }
   // }
   // public class creditCard {
   //     public string cardNumber;
   //     public string expirationDate;
   //     public string cardCode;
   // }
   // public string requestBody(string cardNumber, string expirationDate, string cardCode) {
   //     createTransactionRequest x = new createTransactionRequest();
   //     x.transactionRequest.payment.creditCard.cardNumber = cardNumber;
   //     x.transactionRequest.payment.creditCard.expirationDate = expirationDate;
   //     x.transactionRequest.payment.creditCard.cardCode = cardCode;
   //     return JSON.serialize(x);
   // }
   private String requestBody() {
       // For some reason, the Authorize Dot Net API requires the components of this JSON string to be in a specific order,
       // so we are forced to use the JSON Generator instead of serializing an APEX object.
       // This is lame but out of our control...
       // ----------------- EXAMPLE JSON -----------------
       // {
       //   "createTransactionRequest" : {
       //     "merchantAuthentication" : {
       //       "name" : "XXX",
       //       "transactionKey" : "YYY"
       //     },
       //     "transactionRequest" : {
       //       "transactionType" : "authCaptureTransaction",
       //       "amount" : "13.14",
       //       "payment" : {
       //         "creditCard" : {
       //           "cardNumber" : "5424000000000015",
       //           "expirationDate" : "052018",
       //           "cardCode" : "123"
       //         }
       //       },
       //       "order" : {
       //         "invoiceNumber" : "123"
       //         "description" : "Stuff"
       //       },
       //       "customer" : {
       //         "email" : "ItWasMe@WhoFarted.com"
       //       },
       //       "billTo" : {
       //         "firstName" : "test",
       //         "lastName" : "last",
       //         "address": "1313 Mockingbird Lane",
       //         "zip" : "03062"
       //       },
       //       "transactionSettings" : {
       //         "setting" : {
       //           "settingName" : "emailCustomer",
       //           "settingValue" : "1"
       //         }
       //       }
       //     }
       //   }
       // }
       fetchCredentials();
       JSONGenerator gen = JSON.createGenerator(true);
       gen.writeStartObject();
          gen.writeFieldName('createTransactionRequest');
          gen.writeStartObject();
             gen.writeFieldName('merchantAuthentication');
             gen.writeStartObject();
                gen.writeStringField('name',           credentials.get('key'));
                gen.writeStringField('transactionKey', credentials.get('secret'));
             gen.writeEndObject();
             gen.writeFieldName('transactionRequest');
             gen.writeStartObject();
                gen.writeStringField('transactionType', 'authCaptureTransaction');
                gen.writeStringField('amount', string.valueof(getTotal()));
                gen.writeFieldName('payment');
                gen.writeStartObject();
                   gen.writeFieldName('creditCard');
                   gen.writeStartObject();
                      gen.writeStringField('cardNumber',     ccNumber);
                      gen.writeStringField('expirationDate', expMonth + expYear);
                      gen.writeStringField('cardCode',       ccv);
                   gen.writeEndObject();
                gen.writeEndObject();
                gen.writeFieldName('order');
                gen.writeStartObject();
                   gen.writeStringField('invoiceNumber', 'theRecordId');
                   gen.writeStringField('description', 'description');
                gen.writeEndObject();
                gen.writeFieldName('customer');
                gen.writeStartObject();
                   gen.writeStringField('email', email);
                gen.writeEndObject();
                gen.writeFieldName('billTo');
                gen.writeStartObject();
                   gen.writeStringField('firstName', firstName);
                   gen.writeStringField('lastName',  lastName);
                   gen.writeStringField('address',   street);
                   gen.writeStringField('zip',       zipcode);
                gen.writeEndObject();
                gen.writeFieldName('transactionSettings');
                gen.writeStartObject();
                   gen.writeFieldname('setting');
                   gen.writeStartObject();
                      gen.writeStringField('settingName', 'emailCustomer');
                      gen.writeStringField('settingValue', '1');
                   gen.writeEndObject();
                gen.writeEndObject();
             gen.writeEndObject();
          gen.writeEndObject();
       gen.writeEndObject();
       // This output contains a credit card number, so we shouldn't log it in production where real details are used.
       System.debug('*** JSON output ***');
       System.debug(gen.getAsString());
       return gen.getAsString();
    }
}