public with sharing class RF_Parser {
    public List<RF_Token> tokens;
    public Integer index = 0;

    class RF_ParserException extends Exception { }

    public RF_Parser(List<RF_Token> tokens) {
        this.tokens = tokens;
    }

    public Boolean parse() {
        return expression();
    }

    public Boolean expression() {

        RF_Token current = current();
        if (current != null) {
            Boolean result = term();

            while (current())
        }

        
    }

    public Boolean term() {
        return null;
    }

    public RF_Token consume(List<RF_Token.Type> types) {
        RF_Token currentToken = current();
        if (currentToken == null) {
            return null;
        }
        if (types.contains(currentToken.type)) {
            index++;
            return currentToken;
        } 
        return null;
    }

    public RF_Token current() {
        if (tokens.size() == index) return null;

        return tokens[index];
    }

    public RF_Token current(String type) {
        RF_Token token = current();
        if (token != null && token.type.name() == type) return token;

        return null;
    }

    public RF_Token peek() {
        if (tokens.size() <= index + 1) return null;

        return tokens[index + 1];
    }

    public RF_Token peek(String type) {
        RF_Token token = peek();
        if (token != null && token.type.name() == type) return token;
        
        return null;
    }
}
