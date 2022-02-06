public with sharing class RF_Lex {

    final String source;
    final Integer[] characters;
    final List<RF_Token> tokens = new List<RF_Token>();
    final RF_SymTable symbolTable;

    Integer start = 0;
    Integer current = 0;
    Integer line = 1;

    Map<String, RF_Token.Type> keywords = new Map<StRing, RF_Token.Type> {
        'and' => RF_Token.Type.AND_OP,
        'or' => RF_Token.Type.OR_OP,
        'true' => RF_Token.Type.TRUE_VALUE,
        'false' => RF_Token.Type.FALSE_VALUE,
        'null' => RF_Token.Type.NULL_VALUE
    };

    static Boolean hadError = false;

    public RF_Lex(String source) {
        this.source = source;
        characters = source.getChars();
    }

    public RF_Lex(RF_SymTable symbolTable, String source) {
        this.symbolTable = symbolTable;
        this.source = source;
        characters = source.getChars();
    }

    public List<RF_token> scan() {

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
                        RF_Token.Type.BANG_EQUAL :
                        RF_Token.Type.BANG
                    );
                }
                when 34 { // double quoate " for start of string
                    string();
                }
                when 40 {
                    addToken(RF_Token.Type.LEFT_PAREN);
                }
                when 41 {
                    addToken(RF_Token.Type.RIGHT_PAREN);
                }
                when 42 {
                    addToken(RF_Token.Type.MULT);
                }
                when 43 {
                    addToken(RF_Token.Type.ADD);
                }
                when 45 {
                    addToken(RF_Token.Type.SUB);
                }
                when 47 { // '/' comment
                    if (match(47)) {
                        while (peek() != 10 && !isAtEnd()) advance();
                    } else {
                        addToken(RF_Token.Type.DIV);
                    }
                }
                when 60 {  // < OR <=
                    addToken(
                        match(61) ? 
                        RF_Token.Type.LESS_EQUAL :
                        RF_Token.Type.LESS
                    );
                }
                when 61 {
                    addToken(RF_Token.Type.EQUAL);
                }
                when 62 {
                    addToken(
                        match(61) ? 
                        RF_Token.Type.GREATER_EQUAL :
                        RF_Token.Type.GREATER
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
        addToken(RF_Token.Type.EOF);
        return tokens;
    }

    Boolean isAtEnd() { return current >= characters.size(); }
    Integer advance() { return characters[current++]; }

    void addToken(RF_Token.Type type) { addToken(type, null); }

    void addToken(RF_Token.Type type, Object literal) {
        String text = source.substring(start, current);
        tokens.add(new RF_Token(type, text, literal, line));
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
        addToken(RF_Token.Type.STR, value);
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

        addToken(RF_Token.Type.NUM, Decimal.ValueOf(source.substring(start, current)));
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
        RF_Token.Type type = keywords.get(word.toLowerCase());

        if (type == null) {
            type = RF_Token.Type.IDENTIFIER;
            if (symbolTable != null)
                symbolTable.add(word);
        }

        addToken(type, word);
    }
}
