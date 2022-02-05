public class RF_Sym {
    
    public class RF_SymException extends Exception { }
    public String identifier;
    public Schema.SoapType type;
    public RF_Value.Type valueType;
    
    public RF_Sym(String identifier, Schema.DescribeFieldResult field) {

        this.identifier = identifier;
        type = field.getSoapType();

        switch on type {
            when anytype { unsupported(); }
            when base64binary { unsupported(); }
            when Boolean { valueType = RF_Value.Type.BOOL; }
            when Date { unsupported(); }
            when DateTime { unsupported(); }
            when Double { valueType = RF_Value.Type.NUM; }
            when ID { valueType = RF_Value.Type.STR; }
            when Integer { valueType = RF_Value.Type.NUM; }
            when String { valueType = RF_Value.Type.STR; }
            when Time { unsupported(); }
        }
    }

    void unsupported()  {
        throw new RF_SymException('unsupport symbol type: ' + type.name());
    }
}
