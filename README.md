# About CopyAllFields

SourceObjectとTargetObject間で、次の項目をマッピングし、コピーする機能を持っています。
-API参照名が一致するカスタム項目
-マッピングされたSourceObjectの標準項目とTargetObjectの項目

It has the function to map and copy the following items between SourceObject and TargetObject.
-Custom fields with matching API name
-Mapped standard fields in source object and fields in target object.

## How to user?

### Step1. Mapping Standard fields
copyAllFieldsを拡張します。新しくApex Classを作成し、例えば以下のようにします。
注意
-MapはキーがSource、値がTargetとなりますのでご注意ください。
-項目名は小文字で入力してください

Extends copyAllFields. Create a new Apex Class like following:
note) the Map key is the Source and the value is the Target.

```java
public without sharing class copyAccountAllFields extends copyAllFields {
    public override Map<String, String> standardMapping(){
        Map<String, String> standardFieldMap = new Map<String, String>();
       //Map<sourceFieldName, targetFieldName>->Please enter in LOWER CASE.
        standardFieldMap.put('name','name');
        //Other standard fields similarly.
        return standardFieldMap;
    }
}
```
### Step2 Create Apex Trigger

これができたら次のようなトリガーを書けば出来上がりです。
取引先から取引先へのコピーは無限ループになりますので、止めるためにtriggerCalledクラスを挟んでいます。
https://help.salesforce.com/s/articleView?id=000325747&type=1
リンクを踏むとなぜかtype=5となってしまうので、404が出た場合はURLをコピペしてください。

```java
trigger AccountTrigger on Account (after insert, after update) {
    copyAccountAllFields copy = new copyAccountAllFields();
    if( !triggerCalled.isCalled){
        triggerCalled.isCalled = True;
        copy.runCopy(trigger.new , 'Account');
    }

}
```
