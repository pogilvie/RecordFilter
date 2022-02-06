public with sharing class RF_SymTable {

    public class RF_SymTableException extends Exception { }
    Map<String, Schema.SObjectField> fieldMap;
    Map<String, RF_Sym> table = new Map<String, RF_Sym>();

    public RF_SymTable(String sObjectName) {
        fieldMap = Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap();
    }

    public void add(String fieldName) {
        Schema.SObjectField field = fieldMap.get(fieldName);

        if (field == null) {
            throw new RF_SymTableException('field not found: ' + fieldName);
        }
        table.put(fieldName,  new RF_Sym(fieldName, field.getDescribe()));
    }

    public RF_Value.Type get(String fieldName) {

        RF_Sym symbol = table.get(fieldName);

        if (symbol == null) {
            throw new RF_SymTableException('field not found: ' + fieldName);
        }
        return symbol.valueType;
    }

    public void print() {
        for (String key : table.keySet()) {
            System.debug(table.get(key));
        }
    }
}
