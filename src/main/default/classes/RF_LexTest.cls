@isTest class RF_LexTest {

    @isTest static void symbols() {
        RF_Lex lex = new RF_Lex(new RF_SymTable('Account'), '()!<=>');
        List<RF_Token> tokens = lex.scan();

        for (RF_Token token : tokens) {
            System.debug(token);
        }
    }

    @isTest static void illegalSymbol() {
        RF_Lex lex = new RF_Lex(new RF_SymTable('Account'), '(#)');
        List<RF_Token> tokens = lex.scan();
    }

    @isTest static void comment() {
        List<String> lines = new List<String> {
            '// this is a comment\n',
            '()\n',
            '<=> // end of line comment'
        };
        String source = String.join(lines, ' ');
        RF_Lex lex = new RF_Lex(new RF_SymTable('Account'), source);
        List<RF_Token> tokens = lex.scan();

        for (RF_Token token : tokens) {
            System.debug(token);
        }
    }

    @isTest static void illegalComment() {
        RF_Lex lex = new RF_Lex('/ illegal comment');
        List<RF_Token> tokens = lex.scan();
    }

    @isTest static void string() {
        RF_Lex lex = new RF_Lex(new RF_SymTable('Account'), '"Hello, World!"');
        RF_Token token = lex.scan()[0];
        System.assertEquals(token.type, RF_Token.Type.STR);
        System.assertEquals(token.lexeme, '"Hello, World!"');
        System.assertEquals(token.literal, 'Hello, World!');
    }

    @isTest static void unterminatedString() {
        RF_Lex lex = new RF_Lex(new RF_SymTable('Account'), '"Hello, World!');
        List<RF_Token> tokens = lex.scan();
    }

    @isTest static void number() {
        RF_Lex lex = new RF_Lex(new RF_SymTable('Account'), '10 3.14159');
        RF_Token token = lex.scan()[0];
        System.assertEquals(RF_Token.Type.NUM, token.type);
    }

    @isTest static void lexemes() {
        String source = '!() <!=<=>=> "Hello!" OR AND TRUE false !hello 10 3.14';
        RF_Lex lex = new RF_Lex(source);
        List<RF_Token> tokens = lex.scan();
        for (RF_Token token : tokens) {
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

    @isTest static void symbolTable() {
        String source = ' AccountNumber = "foo" OR NumberOfEmployees > 10 OR AnnualRevenue > 1000000 ';

    }
}

