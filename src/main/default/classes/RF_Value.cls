public class RF_Value {
    class RF_ValueException extends Exception { }
    public enum Type {NUM, STR, DT, BOOL}
    Type type;
    Object value;

    public RF_Value(RF_Value.type type, Object value) {
        this.type = type;
        this.value = value;
    }

    public Decimal toNumberVal() {
        switch on type {
            when NUM { return (Decimal)value; }
            when else { 
                throw new RF_ValueException('Cannot convert type ' + type.name() + ' to number');
            }
        }
    }

    public String toStringVal() {
        switch on type {
            when STR { return (String)value; }
            when else { 
                throw new RF_ValueException('Cannot convert type ' + type.name() + ' to string');
            }
        }
    }


}
