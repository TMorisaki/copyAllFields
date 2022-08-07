@isTest
public without sharing class copyAllFieldsTest {
    private static final String
    NAME_TEST = 'Test',
    SOBJECT_ACCOUNT = 'Account',
    COUNTRY_USA = 'USA',
    CITY_NY = 'New York';

    public without sharing class testCopy extends copyAllFields {
        public override Map<String,String> standardMapping(){
            Map<String, String> standardFieldMap = new Map<String, String>();
            standardFieldMap.put('name','lastname');
            standardFieldMap.put('billingcountry','mailingcountry');
            standardFieldMap.put('billingcity','mailingcity');
            standardFieldMap.put('industory','industory');
            return standardFieldMap;
        }
    }

    @isTest
    static void testExtendedSettings(){
        List<Account> accts = new List<Account>{
            new Account(Name = NAME_TEST, billingCountry = COUNTRY_USA, billingCity = CITY_NY ),
            new Account(Name = NAME_TEST, billingCountry = COUNTRY_USA, billingCity = CITY_NY ),
            new Account(Name = NAME_TEST, billingCountry = COUNTRY_USA, billingCity = CITY_NY )
        };
        testCopy cp = new testCopy();
        insert accts;
        Test.startTest();
        cp.runCopy(accts, 'Contact');
        Test.stopTest();
    }

    @isTest
    static void testDefaultSettings(){
        List<Account> accts = new List<Account>{
            new Account(Name = NAME_TEST, billingCountry = COUNTRY_USA, billingCity = CITY_NY ),
            new Account(Name = NAME_TEST, billingCountry = COUNTRY_USA, billingCity = CITY_NY ),
            new Account(Name = NAME_TEST, billingCountry = COUNTRY_USA, billingCity = CITY_NY )
        };
        copyAllFields cp = new copyAllFields();
        insert accts;
        Test.startTest();
            cp.runCopy(accts, 'Campaign');            
        Test.stopTest();
    }    

}