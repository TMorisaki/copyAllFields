@isTest
public without sharing class copyAllFieldsTest {
    private static final String
    NAME_TEST = 'Test',
    SOBJECT_ACCOUNT = 'Account',
    CITY_NY = 'New York';

    public without sharing class testCopy extends copyAllFields {
        public override Map<String,String> standardMapping(){
            Map<String, String> standardFieldMap = new Map<String, String>();
            standardFieldMap.put('name','lastname');
            standardFieldMap.put('billingcity','mailingcity');
            standardFieldMap.put('industory','industory');
            return standardFieldMap;
        }
    }

    @isTest
    static void testExtendedSettings(){
        List<Account> accts = new List<Account>{
            new Account(Name = NAME_TEST, billingCity = CITY_NY )
        };
        testCopy cp = new testCopy();
        insert accts;
        Test.startTest();
        cp.runCopy(accts, 'Contact');
        System.assertEquals('New York',cp.transferSObjectFieldValues(accts,'Contact')[0].get('MailingCity'));
        System.assertEquals('Test',cp.transferSObjectFieldValues(accts,'Contact')[0].get('LastName'));
        Test.stopTest();
    }

    @isTest
    static void testDefaultSettings(){
        List<Account> accts = new List<Account>{
            new Account(Name = NAME_TEST, billingCity = CITY_NY )
        };
        copyAllFields cp = new copyAllFields();
        insert accts;
        Test.startTest();
            cp.runCopy(accts, 'Campaign');
            System.assertEquals('Test',cp.transferSObjectFieldValues(accts,'Campaign')[0].get('Name'));            
        Test.stopTest();
    }    

    @isTest
    static void testDefaultSettingsNameUnmatch(){
        List<Account> accts = new List<Account>{
            new Account(Name = NAME_TEST, billingCity = CITY_NY )
        };
        copyAllFields cp = new copyAllFields();
        insert accts;
        Test.startTest();
            cp.runCopy(accts, 'Contact');
            System.assertEquals( null ,cp.transferSObjectFieldValues(accts,'Contact')[0].get('LastName'));            
        Test.stopTest();
    }    

}