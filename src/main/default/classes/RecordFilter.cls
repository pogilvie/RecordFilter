public class RecordFilter {

    String source;
    final List<RF_Token> tokens;
    final RF_SymTable symbolTable;
    
    public static void error(Integer line, String msg) {
        System.debug(String.format(
            'Error Line {0}: {1}',
            new List<Object> { line, msg }
        ));
    }

    public RecordFilter(String sObjectName, String source) {
        this.source = source;
        symbolTable = new RF_SymTable(sObjectName);
        RF_Lex lex = new RF_Lex(symbolTable, source);
        tokens = lex.scan();
        System.debug(tokens);
    }
    
    public Boolean match(SObject record) {
        RF_Parse p = new RF_Parse(symbolTable, tokens, record);
        RF_Value result = p.parse();
        return result.toBooleanVal();
    }
}
