public class RF_Visitor {
    public Map<String, RF_Value> variables;
    String buffer;

    void init() {
        variables = new Map<String, RF_Value>();
        buffer = '';
    }

    public void run(String source) {
        init();
        List<RF_Token> tokens = new RF_Lex(source).scann();
        System.debug(tokens);
        Boolean result  = new RF_Parser(tokens).parse();
        System.debug(result);
        // for (RF_Node node : nodes) {
        //     visit(node);
        // }
  
    }

    void visit(RF_Node node) {
        RF_Value result = node.accept(this);
    }

    public RF_Value visitBinaryOperator(RF_BinaryOperatorNode node) {
        RF_Value leftValue = node.left.accept(this);
        RF_Value rightValue = node.right.accept(this);

        switch on node.type.type {
            when AND_OP {
                return new RF_Value(leftValue.value && rightValue.value, null);
            }
            when OR_OP {
                return new RF_Value(leftValue.value || rightValue.value, null);
            }
        }

        return null;

    }

}
