public with sharing class RFLex {

    final String source;
    final Integer[] characters;
    final List<RFToken> tokens = new List<RFToken>();

    Integer start = 0;
    Integer current = 0;
    Integer line = 1;

    Map<String, RFToken.TokenType> keywords = new Map<StRing, RFToken.TokenType> {
        'and' => RFToken.TokenType.AND_OP,
        'or' => RFToken.TokenType.OR_OP,
        'true' => RFToken.TokenType.TRUE_VALUE,
        'false' => RFToken.TokenType.FALSE_VALUE,
        'null' => RFToken.TokenType.NULL_VALUE
    };

    static Boolean hadError = false;

    public RFLex(String source) {
        this.source = source;
        characters = source.getChars();
    }

    public List<RFtoken> scann() {

        while (!isAtEnd()) {
            start = current;
            Integer c = advance();
            switch on c {
                when 10 { // newline \n
                    line++;
                }
                when 11 { /* ignore whitespace (tab character \t) */ }
                when 13 { /* ignore whitespace (carrage return character \r) */ }
                when 32 { /* ignore whitespace (space character) */ }
                when 33 {  // ! OR !=
                    addToken(
                        match(61) ? 
                        RFToken.TokenType.BANG_EQUAL :
                        RFToken.TokenType.BANG
                    );
                }
                when 34 { // double quoate " for start of string
                    string();
                }
                when 40 {
                    addToken(RFToken.TokenType.LEFT_PAREN);
                }
                when 41 {
                    addToken(RFToken.TokenType.RIGHT_PAREN);
                }
                when 47 { // '/' comment
                    if (match(47)) {
                        while (peek() != 10 && !isAtEnd()) advance();
                    } else {
                        report(c);
                    }
                }
                when 60 {  // < OR <=
                    addToken(
                        match(61) ? 
                        RFToken.TokenType.LESS_EQUAL :
                        RFToken.TokenType.LESS
                    );
                }
                when 61 {
                    addToken(RFToken.TokenType.EQUAL);
                }
                when 62 {
                    addToken(
                        match(61) ? 
                        RFToken.TokenType.GREATER_EQUAL :
                        RFToken.TokenType.GREATER
                    );
                } when else {
                    if (isDigit(c)) {
                        number();
                    } else if (isAlpha(c)) {
                        identifier();
                    } else {
                        report(c);
                    }
                }
            }
        }

        return tokens;
    }

    Boolean isAtEnd() { return current >= characters.size(); }
    Integer advance() { return characters[current++]; }

    void addToken(RFToken.TokenType type) { addToken(type, null); }

    void addToken(RFToken.TokenType type, Object literal) {
        String text = source.substring(start, current);
        tokens.add(new RFToken(type, text, literal, line));
    }

    void report(Integer c) {
        RecordFilter.error(
            line,
            'Ilegal Chaaracter: ' + 
            String.fromCharArray(new Integer[] { c })
        );
    }

    Integer peek() {
        if (isAtEnd()) return 0;
        return characters[current];
    }

    Boolean match(Integer expected) {
        if (isAtEnd()) return false;
        if (characters[current] != expected) return false;

        current++;
        return true;
    }

    void string() {
        while (peek() != 34 && !isAtEnd()) {
            if (peek() == 10) line++;
            advance();
        }

        if (isAtEnd()) {
            RecordFilter.error(line, 'Unterminated string');
            return;
        }

        // the closing "
        advance();
        String value = source.substring(start + 1, current - 1);
        addToken(RFToken.TokenType.STR, value);
    }

    Boolean isDigit(Integer c) {
        return (
            (c >= 48 && c <= 57) || (c == 46)
        );
    }

    Integer peekNext() {
        if (current + 1 >= source.length()) return 0;

        return characters[current + 1];
    }

    void number() {
        while (isDigit(peek())) advance();

        if (peek() == 46 && isDigit(peekNext())) {
            // consume '.'
            advance();
        }

        while (isDigit(peek())) advance();

        addToken(RFToken.TokenType.NUM, Decimal.ValueOf(source.substring(start, current)));
    }

    Boolean isAlpha (Integer c) {
        return (
            (c >= 65 && c <= 90) ||
            (c >= 97 && c <= 122) || 
            c == 95
        );
    }

    Boolean isAlphaNumeric(Integer c) {
        return isAlpha(c) || isDigit(c);
    }

    void identifier() {
        while (isAlphaNumeric(peek())) advance();

        String word = source.substring(start, current);
        RFTOken.TokenType type = keywords.get(word.toLowerCase());

        if (type == null) {
            type = RFToken.TokenType.IDENTIFIER;
        }

        addToken(type);
    }
}
