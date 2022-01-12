public with sharing class RFLex {
    static final Integer LEFT_PAREN_CHAR = Integer.valueOf('(');
    static final Integer RIGHT_PAREN_CHAR = Integer.valueOf(')');
    static final Integer EQUAL_CHAR = Integer.valueOf('=');
    static final Integer BANG_CHAR = Integer.valueOf('!');
    static final Integer LESS_THAN_CHAR = Integer.valueOf('<');
    static final Integer GREATER_THAN_CHAR = Integer.valueOf('<');

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
        }

        return null;
    }

    Boolean isAtEnd() { return current >= characters.size(); }
    Integer advance() { return 0; }
}
