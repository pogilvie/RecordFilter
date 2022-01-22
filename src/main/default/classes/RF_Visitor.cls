public class RF_Visitor {
    public Map<String, RF_Value> variables;
    String buffer;

    void init() {
        variables = new Map<String, RF_Value>();
        buffer = '';
    }

    public void run(String source) {
        init();
        List<RFToken> tokens = new RFLex(source).scann();
        List<RF_Node> nodes = new RF_Parser(tokens).parse();
        for (RF_Node node : nodes) {
            visit(node);
        }
  
    }

    void visit(RF_Node node) {
        RF_Value result = node.accept(this);
    }

}
