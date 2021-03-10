public without sharing class TeslaControl {
    public TeslaControl() {
    }

    public static string authorize() {

        
        httpresponse response = utilities.api_call('GET', 'https://auth.tesla.com/oauth2/v3/authorize', null, '{"redirect_uri" : "https://auth.tesla.com/void/callback"}');


        System.debug(response);
        return response.getbody();

 

    }
}
