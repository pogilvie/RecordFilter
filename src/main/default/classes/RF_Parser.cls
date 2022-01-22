public with sharing class RF_Parser {
    public List<RFToken> tokens;
    public Integer index = 0;

    public RF_Parser(List<RFToken> tokens) {
        this.tokens = tokens;
    }

    public List<RF_Node> parse() {
        return expression();
    }

    public List<RF_Node> expression() {
        return null;
    }

    public RFToken consume(String type) {
        RFToken currentToken = current();
        if (currentToken == null) {
            return null;
        }
        if (currentToken.type.name() == type) {
            index++;
            return currentToken;
        } 
        return null;
    }

    public RFToken current() {
        if (tokens.size() == index) return null;

        return tokens[index];
    }

    public RFToken current(String type) {
        RFToken token = current();
        if (token != null && token.type.name() == type) return token;

        return null;
    }

    public RFToken peek() {
        if (tokens.size() <= index + 1) return null;

        return tokens[index + 1];
    }

    public RFToken peek(String type) {
        RFToken token = peek();
        if (token != null && token.type.name() == type) return token;
        
        return null;
    }
}
