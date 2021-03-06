global class AuthorizeDotNet {
    public class Response {
        public TransactionResponse transactionResponse;
        public string refId;
        public Messages messages;
    }
    public class TransactionResponse {
        public string responseCode;
        public string authCode;
        public string avsResultCode;
        public string cvvResultCode;
        public string cavvResultCode;
        public string transId;
        public string refTransID;
        public string transHash;
        public string testRequest;
        public string accountNumber;
        public string accountType;
        public string transHashSha2;
        public integer SupplementalDataQualificationIndicator;
        public string networkTransId;
        public Message[] messages;
        public Error[] errors;
        public userField[] userFields;
    }
    public class Message {
        public string code;
        public string description;
        public string text; 
    }
    public class Messages {
        public string resultCode;
        public Message[] message;
    }
    public class userField {
        public string name;
        public string value;
    }
    public class Error {
        public string errorCode;
        public string errorText;
    }
// failed response
    // {
    //     "transactionResponse": {
    //         "responseCode": "3",
    //         "authCode": "",
    //         "avsResultCode": "P",
    //         "cvvResultCode": "",
    //         "cavvResultCode": "",
    //         "transId": "0",
    //         "refTransID": "",
    //         "transHash": "",
    //         "testRequest": "0",
    //         "accountNumber": "XXXX0015",
    //         "accountType": "MasterCard",
    //         "errors": [
    //             {
    //                 "errorCode": "8",
    //                 "errorText": "The credit card has expired."
    //             }
    //         ],
    //         "userFields": [
    //             {
    //                 "name": "MerchantDefinedFieldName1",
    //                 "value": "MerchantDefinedFieldValue1"
    //             },
    //             {
    //                 "name": "favorite_color",
    //                 "value": "blue"
    //             }
    //         ],
    //         "transHashSha2": "",
    //         "SupplementalDataQualificationIndicator": 3
    //     },
    //     "refId": "123456",
    //     "messages": {
    //         "resultCode": "Error",
    //         "message": [
    //             {
    //                 "code": "E00027",
    //                 "text": "The transaction was unsuccessful."
    //             }
    //         ]
    //     }
    // }
    // Successful
    // {
    //     "transactionResponse": {
    //         "responseCode": "1",
    //         "authCode": "DT2YUH",
    //         "avsResultCode": "Y",
    //         "cvvResultCode": "P",
    //         "cavvResultCode": "2",
    //         "transId": "40059666133",
    //         "refTransID": "",
    //         "transHash": "",
    //         "testRequest": "0",
    //         "accountNumber": "XXXX0015",
    //         "accountType": "MasterCard",
    //         "messages": [
    //             {
    //                 "code": "1",
    //                 "description": "This transaction has been approved."
    //             }
    //         ],
    //         "userFields": [
    //             {
    //                 "name": "MerchantDefinedFieldName1",
    //                 "value": "MerchantDefinedFieldValue1"
    //             },
    //             {
    //                 "name": "favorite_color",
    //                 "value": "blue"
    //             }
    //         ],
    //         "transHashSha2": "",
    //         "SupplementalDataQualificationIndicator": 3,
    //         "networkTransId": "2PWVWY02FLVM73MB5FICUIO"
    //     },
    //     "refId": "123456",
    //     "messages": {
    //         "resultCode": "Ok",
    //         "message": [
    //             {
    //                 "code": "I00001",
    //                 "text": "Successful."
    //             }
    //         ]
    //     }
    // }
}