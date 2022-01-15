@isTest class RFLexTest {

    @isTest static void symbols() {
        RFLex lex = new RFLex('()!<=>');
        List<RFToken> tokens = lex.scann();

        for (RFToken token : tokens) {
            System.debug(token);
        }
    }

    @isTest static void illegalSymbol() {
        RFLex lex = new RFLex('(#)');
        List<RFToken> tokens = lex.scann();
    }

    @isTest static void comment() {
        List<String> lines = new List<String> {
            '// this is a comment\n',
            '()\n',
            '<=> // end of line comment'
        };
        String source = String.join(lines, ' ');
        RFLex lex = new RFLex(source);
        List<RFToken> tokens = lex.scann();

        for (RFToken token : tokens) {
            System.debug(token);
        }
    }

    @isTest static void illegalComment() {
        RFLex lex = new RFLex('/ illegal comment');
        List<RFToken> tokens = lex.scann();
    }

    @isTest static void string() {
        RFLex lex = new RFLex('"Hello, World!"');
        List<RFToken> tokens = lex.scann();
        
        for (RFToken token : tokens) {
            System.debug(token);
            System.assertEquals(token.type, RFToken.TokenType.STR);
            System.assertEquals(token.lexeme, '"Hello, World!"');
            System.assertEquals(token.literal, 'Hello, World!');
        }
    }

    @isTest static void unterminatedString() {
        RFLex lex = new RFLex('"Hello, World!');
        List<RFToken> tokens = lex.scann();
    }

    @isTest static void number() {
        RFLex lex = new RFLex('10 3.14159');
        List<RFToken> tokens = lex.scann();
        for (RFToken token : tokens) {
            System.debug(token);
            System.assertEquals(token.type, RFToken.TokenType.NUM);
        }
    }

    @isTest static void lexemes() {
        String source = '!() <!=<=>=> "Hello!" OR AND TRUE false !hello 10 3.14';
        RFLex lex = new RFLex(source);
        List<RFToken> tokens = lex.scann();
        for (RFToken token : tokens) {
            System.debug(token);
        }
        System.assertEquals(tokens[0].type.name(), 'BANG');
        System.assertEquals(tokens[1].type.name(), 'LEFT_PAREN');
        System.assertEquals(tokens[2].type.name(), 'RIGHT_PAREN');
        System.assertEquals(tokens[3].type.name(), 'LESS');
        System.assertEquals(tokens[4].type.name(), 'BANG_EQUAL');
        System.assertEquals(tokens[5].type.name(), 'LESS_EQUAL');
        System.assertEquals(tokens[6].type.name(), 'GREATER_EQUAL');
        System.assertEquals(tokens[7].type.name(), 'GREATER');
        System.assertEquals(tokens[8].type.name(), 'STR');
        System.assertEquals(tokens[9].type.name(), 'OR_OP');
        System.assertEquals(tokens[10].type.name(), 'AND_OP');
        System.assertEquals(tokens[11].type.name(), 'TRUE_VALUE');
        System.assertEquals(tokens[12].type.name(), 'FALSE_VALUE');
        System.assertEquals(tokens[13].type.name(), 'BANG');
        System.assertEquals(tokens[14].type.name(), 'IDENTIFIER');
        System.assertEquals(tokens[15].type.name(), 'NUM');
        System.assertEquals(tokens[16].type.name(), 'NUM');
    }

}

