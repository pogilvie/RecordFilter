public with sharing class RFLex {

    final String source;
    final Integer[] characters;
    final List<RFToken> tokens = new List<RFToken>();

    Integer start = 0;
    Integer current = 0;
    Integer line = 1;

    static Boolean hadError = false;

    public RFLex(String source) {
        this.source = source;
        characters = source.getChars();
    }

    List<RFtoken> scann() {

        while (!isAtEnd()) {
            start = current;
            Integer c = advance();
            switch on c {
                when 33 {
                    addToken(RFToken.TokenType.BANG);
                }
                when 40 {
                    addToken(RFToken.TokenType.LEFT_PAREN);
                }
                when 41 {
                    addToken(RFToken.TokenType.RIGHT_PAREN);
                }
                when 60 {
                    addToken(RFToken.TokenType.LESS);
                }
                when 61 {
                    addToken(RFToken.TokenType.EQUAL);
                }
                when 62 {
                    addToken(RFToken.TokenType.GREATER);
                } when else {
                    System.debug('Ilegal Chaaracter: ' + c);
                }
            }
        }

        return null;
    }

    Boolean isAtEnd() { return current >= characters.size(); }
    Integer advance() { return characters[current++]; }

    void addToken(RFToken.TokenType type) { addToken(type, null); }

    void addToken(RFToken.TokenType type, Object literal) {
        String text = source.substring(start, current);
        tokens.add(new RFToken(type, text, literal, line));
    }
}
