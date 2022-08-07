public without sharing class copyAccountAllFields extends copyAllFields {
    public override Map<String, String> standardMapping(){
        Map<String, String> standardFieldMap = new Map<String, String>();
       //Map<sourceFieldName, targetFieldName>->Please enter in LOWER CASE.
        standardFieldMap.put('name','name');
        //Other standard fields similarly.
        return standardFieldMap;
    }
}