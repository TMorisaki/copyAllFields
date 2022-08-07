public without sharing virtual class copyAllFields {

    //call this method in Apex Trigger
    public void runCopy(List<SObject> sourceList, String targetObjectString) {
        List<SObject> targets = transferSObjectFieldValues(sourceList, targetObjectString);
        insert targets;
    }
    
    //override this method in extends Apex Class
    public virtual Map<String, String> standardMapping(){
        Map<String, String> standardFieldMap = new Map<String, String>();
        //Map<sourceFieldName, targetFieldName>
        standardFieldMap.put('Name','Name');
        //Other standard fields similarly.
        return standardFieldMap;
    }    

    //Logic
    public List<SObject> transferSObjectFieldValues(List<SObject> sourceList, String targetObjectString){
        Set<String> fields = sourceList.getSobjectType().getDescribe().fields.getMap().keySet();

        SObject targetObject = Schema.getGlobalDescribe().get(targetObjectString).newSObject();
        SObjectType targetType = ((SObject) Type.forName(targetObjectString).newInstance()).getSObjectType();
        Map<String, Schema.SObjectField> targetfields = targetObject.getsObjectType().getDescribe().fields.getMap();

        Map<String, String> standardMap = new Map<String, String>(standardMapping());
        System.debug(standardMap);
        
        List<SObject> co2 = new List<SObject>();
        for(SObject record: sourceList) {
            SObject clone = targetType.newSObject();
            for(String field:fields) {
                //This will only copy custom fields of sourceObject and assumes that field api name is similar in targetobject
                if(field.indexOf('__c')>-1){
                    if (targetfields.containsKey(field)){
                        clone.put(field, record.get(field));
                    }
                }else if(standardMap.containsKey(field)){
                    system.debug('There is a field;' + field);
                    clone.put(standardMap.get(field), record.get(field));
                }else{
                    system.debug('There is not a field;' + field);
                }
                //mention other standard fields similarly, system fields such as Id, createdDate etc can not be copied. 
            }
            co2.add(clone);
        }
        System.debug(co2);
        return co2;
    }
}