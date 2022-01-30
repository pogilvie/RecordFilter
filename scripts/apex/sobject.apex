
Case cs = [SELECT Id, Subject, Origin FROM Case];

SObjectType type = cs.getSObjectType();

System.debug(JSON.serializePretty(type.getDescribe()));

Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Case.fields.getMap();


Schema.SObjectField T = fieldMap.get('Origin');
Schema.DescribeFieldResult F = T.getDescribe();

