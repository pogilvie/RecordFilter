public class RF_BinaryOperatorNode implements RF_Node {
    public RF_Token type;
    public RF_Node left;
    public RF_Node right;

    public RF_Value accept(RF_Visitor v) {
        return v.visitBinaryOperator(this);
    }
}
