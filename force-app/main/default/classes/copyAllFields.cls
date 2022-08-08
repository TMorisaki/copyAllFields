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
        Schema.DescribeSObjectResult sourceDsr = sourceList.getSobjectType().getDescribe();
        Map<String, Schema.SObjectField> sourceFields = sourceDsr.fields.getMap();

        Map<String, Schema.SObjectField> targetfields = Schema.getGlobalDescribe().get(targetObjectString)
                                                        .newSObject().getSObjectType().getDescribe().fields.getMap();

        Map<String, String> standardMap = new Map<String, String>(standardMapping());
        System.debug(standardMap);
        
        List<SObject> co2 = new List<SObject>();
        for(SObject record: sourceList) {
            SObject targetObject = Schema.getGlobalDescribe().get(targetObjectString).newSObject();
            targetObject.clear();
            for(String sourceField:sourceFields.keySet()) {
                if(sourceFields.get(sourceField).getDescribe().isCustom()){
                    if (targetfields.containsKey(sourceField)){
                        targetObject.put(sourceField, record.get(sourceField));
                    }
                }else if(standardMap.containsKey(sourceField) && targetfields.containsKey(standardMap.get(sourceField))){
                    try {
                        system.debug('Field exists;' + sourceField);
                        targetObject.put(standardMap.get(sourceField), record.get(sourceField));
                    } catch (SObjectException e) {
                        System.debug('The following exception has occurred: ' + e.getMessage());
                    }
                    
                }else{
                    system.debug('Field does not exist;' + sourceField);
                }
            }
            co2.add(targetObject);
        }
        System.debug(co2);
        return co2;
    }
}