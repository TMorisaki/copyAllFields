trigger AccountTrigger on Account (after insert, after update) {
    copyAccountAllFields copy = new copyAccountAllFields();
    if( !triggerCalled.isCalled){
        triggerCalled.isCalled = True;
        copy.runCopy(trigger.new , 'Account');
    }

}