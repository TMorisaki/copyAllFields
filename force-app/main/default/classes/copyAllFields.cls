public without sharing virtual class copyAllFields {

    //call this method in Apex Trigger
    public void runCopy(List<SObject> sourceList, String targetObjectString) {
        List<SObject> targets = transferSObjectFieldValues(sourceList, targetObjectString);
        try {
            insert targets;
        } catch (DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }
    
    //override this method in extends Apex Class
    public virtual Map<String, String> standardMapping(){
        Map<String, String> standardFieldMap = new Map<String, String>();
        //Map<sourceFieldName, targetFieldName>
        standardFieldMap.put('name','name');
        //Other standard fields similarly.
        return standardFieldMap;
    }    

    //Logic
    public List<SObject> transferSObjectFieldValues(List<SObject> sourceList, String targetObjectString){
        Set<String> sourceFields = sourceList.getSobjectType().getDescribe().fields.getMap().keySet();

        SObject targetObject = Schema.getGlobalDescribe().get(targetObjectString).newSObject();
        SObjectType targetType = ((SObject) Type.forName(targetObjectString).newInstance()).getSObjectType();
        Map<String, Schema.SObjectField> targetfields = targetObject.getsObjectType().getDescribe().fields.getMap();

        Map<String, String> standardMap = new Map<String, String>(standardMapping());
        System.debug(standardMap);
        
        List<SObject> co2 = new List<SObject>();
        for(SObject record: sourceList) {
            SObject clone = targetType.newSObject();
            for(String field:sourceFields) {
                //This will only copy custom fields of sourceObject and assumes that field api name is similar in targetobject
                if(field.indexOf('__c')>-1){
                    if (targetfields.containsKey(field)){
                        clone.put(field, record.get(field));
                    }
                }else if(standardMap.containsKey(field) && targetfields.containsKey(field)){
                    try {
                        system.debug('Field exists;' + field);
                        clone.put(standardMap.get(field), record.get(field));
                    } catch (SObjectException e) {
                        System.debug('The following exception has occurred: ' + e.getMessage());
                    }
                    
                }else{
                    system.debug('Field does not exist;' + field);
                }
            }
            co2.add(clone);
        }
        System.debug(co2);
        return co2;
    }
}