public class RF_Value {
    public RF_Node original;
    public String value;

    public RF_Value(String value, RF_Node original) {
        this.value = value;
        this.original = original;
    }

    public Integer getInteger() {
        return Integer.valueOf(value);
    }

    public String getString() {
        return value;
    }
}
