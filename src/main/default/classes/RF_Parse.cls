public with sharing class RF_Parse {
    RF_Stack stack = new RF_Stack();
    final List<RF_Token> tokens;
    final RF_SymTable symbolTable;
    public Integer index = 0;
    Integer counter = 0;
    SObject record;

    public class RF_ParseException extends Exception { }

    public RF_Parse(RF_SymTable symbolTable, List<RF_Token> tokens, SObject record) {
        this.symbolTable = symbolTable;
        this.tokens = tokens;
        this.record = record;
    }

    public RF_Value parse() {
        expression();
        stack.print();
        return stack.pop();
    }

    // <expression> --> <term> ( ('AND'|'OR') <term> )*
    // <term> --> <comparison> ( ('='|'!='|'<'|''>'|'<='|>=) <comparison> )*
    // <comparison> --> ID | CONST | '(' <expression> ')'
    // terminals { ID, CONST, (, ) }
    
    // <expression> --> <term> ( ('AND'|'OR') <term> )*
    public void expression() {
        recursionCheck();
        term();
        while (isTermOperator()) {
            Boolean left = stack.pop().toBooleanVal();
            RF_Token token = advance();
            term();
            Boolean right = stack.pop().toBooleanVal();

            Boolean result;
            switch on token.type {
                when AND_OP {
                    result = left && right;
                }
                when OR_OP {
                    result = left || right;
                }
            }
            stack.push(new RF_Value(RF_Value.Type.BOOL, result));
        }
    }

    // <term> --> <comparison> ( ('='|'!='|'<'|''>'|'<='|>=) <comparison> )*
    public void term() {
        unary();
        while (isComparisonOperator()) {
            RF_Value left = stack.pop();
            RF_Token token = advance();
            unary();
            RF_Value right = stack.pop();

            Boolean isNumberType = (left.type == RF_Value.type.NUM);
            Boolean isNullType = (left.type == RF_Value.Type.NULL_VALUE || right.type == RF_Value.Type.NULL_VALUE);

            if (!isNullType && left.type != right.type) {
                throw new RF_ParseException(
                    String.format('cannot compare type {0} with type {1}', 
                    new List<Object> { 
                        left.type.name(),
                        right.type.name() 
                    })
                );
            } 

            Boolean result;
            switch on token.type {
                when EQUAL {
                    if (isNumberType)
                        result = left.toNumberVal() == right.toNumberVal();
                    else if (isNullType)
                        result = right.value == left.value;
                    else
                        result = left.toStringVal() == right.toStringVal();
                }
                when BANG_EQUAL {
                    if (isNumberType)
                        result = left.toNumberVal() != right.toNumberVal();
                    else if (isNullType)
                        result = right.value != left.value;
                    else
                        result = left.toStringVal() != right.toStringVal();
                }
                when LESS {
                    if (isNumberType)
                        result = left.toNumberVal() < right.toNumberVal();
                    else if (isNullType)
                        throw new RF_ParseException('Only = and != operators supported for null comparisons');
                    else
                        result = left.toStringVal() < right.toStringVal();
                }
                when GREATER {
                    if (isNumberType)
                        result = left.toNumberVal() > right.toNumberVal();
                    else if (isNullType)
                        throw new RF_ParseException('Only = and != operators supported for null comparisons');
                    else
                        result = left.toStringVal() > right.toStringVal();
                }
                when LESS_EQUAL {
                    if (isNumberType)
                        result = left.toNumberVal() <= right.toNumberVal();
                    else if (isNullType)
                        throw new RF_ParseException('Only = and != operators supported for null comparisons');
                    else
                        result = left.toStringVal() <= right.toStringVal();
                }
                when GREATER_EQUAL {
                    if (isNumberType)
                        result = left.toNumberVal() >= right.toNumberVal();
                    else if (isNullType)
                        throw new RF_ParseException('Only = and != operators supported for null comparisons');
                    else
                        result = left.toStringVal() >= right.toStringVal();
                }
            }
            stack.push(new RF_Value(RF_Value.Type.BOOL, result));
        }
    }

    public void unary() {
        Boolean isNOT = false;

        if (current().type == RF_Token.Type.BANG) {
            match(RF_Token.type.BANG);
            isNot = true;
        }
        comparison();

        if (isNot) {
            RF_Value value = stack.pop();
            if (value.type != RF_Value.Type.BOOL) {
                throw new RF_ParseException('Logical not (!) applied to non boolean expression.');
            }
            if (value.toBooleanVal()) {
                stack.push(new RF_Value(RF_Value.Type.BOOL, false));
            } else {
                stack.push(new RF_Value(RF_Value.Type.BOOL, true));
            }
        }
    }

    // <comparison> --> ID | CONST | '(' <expression> ')'
    public void comparison() {
        RF_Token token = current();
        switch on token.type {
            when IDENTIFIER {
                match(RF_Token.Type.IDENTIFIER);
                stack.push(resolveIdentifier(token));
            }
            when STR {
                match(RF_Token.Type.STR);
                stack.push(new RF_Value(RF_Value.Type.STR, token.literal));
            }
            when NUM {
                match(RF_Token.Type.NUM);
                stack.push(new RF_Value(RF_Value.Type.NUM, token.literal));
            }
            when TRUE_VALUE {
                match(RF_Token.Type.TRUE_VALUE);
                stack.push(new RF_Value(RF_Value.Type.BOOL, true));
            }
            when FALSE_VALUE {
                match(RF_Token.Type.FALSE_VALUE);
                stack.push(new RF_Value(RF_Value.Type.BOOL, false));
            }
            when NULL_VALUE {
                match(RF_Token.Type.NULL_VALUE);
                stack.push(new RF_Value(RF_Value.Type.NULL_VALUE, null));
            }
            when LEFT_PAREN {
                match(RF_Token.Type.LEFT_PAREN);
                expression();
                match(RF_Token.Type.RIGHT_PAREN);
            }
            when else {
                throw new RF_ParseException(
                    String.format('comparison unexpected token: {0}', new List<Object> { token.type.name() })
                );
            } 
        }
    }

    RF_Value resolveIdentifier(RF_Token token) {

        String field = String.valueOf(token.literal);
        Object value;
        RF_Value.Type type;

        value = record.get(field);

        System.debug(
            String.format(
                'resolveIdentifier: field {0} has value {1}', 
                new List<Object> { field, value }
            )
        );

        if (value == null) {
            type = RF_Value.Type.NULL_VALUE; 
        } else {
            type = symbolTable.get(field);
        }

        return new RF_Value(type, value);
    }


    RF_Token advance() {
        RF_Token token = current();
        if (token == null) {
            throw new RF_ParseException('No more tokens on advance');
        }
        index += 1;
        return token;
    }

    public RF_Token current() {
        if (tokens.size() == index) return null;

        return tokens[index];
    }

    void match(RF_Token.Type type) {
        if (tokens[index].type == type && index <= tokens.size()) {
            index++;
        } else {
            throw new RF_ParseException(
                String.format(
                    'match current: {0} expecting: {1}', 
                    new List<Object> { tokens[index].type.name(), type.name() }
                )
            );
        }
    }

    // true if 'AND' | 'OR'
    boolean isTermOperator() {
        RF_Token.Type type = tokens[index].type;
        return 
            type == RF_Token.Type.AND_OP ||
            type == RF_Token.Type.OR_OP;
    }

    // true if '='|'!='|'<'|''>'|'<='|>=
    boolean isComparisonOperator() {
        RF_Token.Type type = tokens[index].type;
        return 
            type == RF_Token.Type.EQUAL ||
            type == RF_Token.Type.BANG_EQUAL ||
            type == RF_Token.Type.LESS ||
            type == RF_Token.Type.GREATER ||
            type == RF_Token.Type.LESS_EQUAL ||
            type == RF_Token.Type.GREATER_EQUAL; 
    }

    @testVisible
    void recursionCheck() {
        if (counter > 15) {
            String msg = String.format(
                'expression infinite recursion suspected {0}', new List<Object> { counter }
            );
            throw new RF_ParseException(msg);
        }
        counter += 1;
    }
}
