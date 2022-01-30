public class RecordFilter {

    String source;
    final List<RF_Token> tokens;
    
    public static void error(Integer line, String msg) {
        System.debug(String.format(
            'Error Line {0}: {1}',
            new List<Object> { line, msg }
        ));
    }

    public RecordFilter(String source) {
        this.source = source;
        RF_Lex lex = new RF_Lex(source);
        tokens = lex.scann();
        System.debug(tokens);
    }
    
    public Boolean match(SObject record) {
        RF_Parse p = new RF_Parse(tokens, record);
        RF_Value result = p.parse();
        return result.toBooleanVal();
    }
}
