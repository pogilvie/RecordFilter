public class Demo {

    public final List<RF_Token> tokens;
    RF_Stack stack = new RF_Stack();
    public Integer index = 0;
    Integer counter = 0;

    class DemoException extends Exception { }

    public Demo(List<RF_Token> tokens) {
        this.tokens = tokens;
    }

    // <assignment> --> ID '=' <expression> EOF
    // <expression> --> <term> ( ('+'|'-') <term> )*
    // <term> --> <factor> ( ('*'|'/') <factor> )*
    // <factor> --> ID | CONST | '(' <expression> ')'
    // terminals { ID, CONST, (, ), +, -, *, /, ;, =}

    public void parse() {
        RF_Stack stack;
        System.debug(tokens);
        assignment();
    }

    void match(RF_Token.Type type) {
        if (tokens[index].type == type && index <= tokens.size()) {
            index++;
        } else {
            String msg = String.format(
                'match current: {0} expecting: {1}', 
                new List<Object> { tokens[index].type.name(), type.name() }
            );
            throw new DemoException(msg);
        }
    }

    // <assignment> --> ID '=' <expression> EOF
    void assignment() {
        match(RF_Token.Type.IDENTIFIER);
        match(RF_Token.Type.EQUAL);
        expression();
        match(RF_Token.Type.EOF);
        stack.print();
    }

    // <expression> --> <term> ( ('+'|'-') <term> )*
    void expression() {
        recursionCheck();
        term();
        while (isTermOperator()) {
            Decimal left = stack.pop().toNumberVal();
            RF_Token.type operator = peek().type;
            match(peek().type);
            term();
            Decimal right = stack.pop().toNumberVal();
            Decimal result;
            switch on operator {
                when ADD {
                    result = left + right;
                }
                when SUB {
                    result = left - right;
                }
            }
            stack.push(new RF_Value(RF_Value.Type.NUM, result));
        }
    }

    // <term> --> <factor> ( ('*'|'/') <factor> )*
    void term() {
        factor();
        while (isFactorOperator()) {
            Decimal left = stack.pop().toNumberVal();
            RF_Token.type operator = peek().type;
            match(peek().type);
            factor();
            Decimal right = stack.pop().toNumberVal();
            Decimal result;
            switch on operator {
                when MULT {
                    result = left * right;
                }
                when DIV {
                    result = left / right;
                }
            }
            stack.push(new RF_Value(RF_Value.Type.NUM, result));
        }
    }

    // <factor> --> ID | CONST | '(' <expression> ')'
    void factor() {
        RF_Token token = peek();
        switch on token.type {
            when IDENTIFIER {
                match(RF_Token.Type.IDENTIFIER);
                stack.push(new RF_Value(RF_Value.Type.STR, token.literal));
            }
            when NUM {
                match(RF_Token.Type.NUM);
                stack.push(new RF_Value(RF_Value.Type.NUM, token.literal));
            }
            when LEFT_PAREN {
                match(RF_Token.Type.LEFT_PAREN);
                expression();
                match(RF_Token.Type.RIGHT_PAREN);
            }
            when else {
                String msg = String.format('factor expecting: {0}', new List<Object> { token.type.name() });
                throw new DemoException(msg);
            }
        }
    }

    RF_Token peek() {
        if (index <= tokens.size()) {
            return tokens[index];
        } else {
            return null;
        }
    }

    // true if '+' or '-'
    boolean isTermOperator() {
        return 
            tokens[index].type == RF_Token.Type.ADD ||
            tokens[index].type == RF_Token.Type.SUB ;
    }

    boolean isFactorOperator() {
        return 
            tokens[index].type == RF_Token.Type.MULT ||
            tokens[index].type == RF_Token.Type.DIV ;
    }

    void recursionCheck() {
        if (counter > 15) {
            String msg = String.format(
                'expression infinite recurtion suspected {0}', new List<Object> { counter }
            );
            throw new DemoException(msg);
        }
        counter += 1;
    }

}
