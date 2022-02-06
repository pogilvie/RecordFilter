
Account record = new Account(
    AccountNumber = 'COIN',
    NumberOfEmployees = 3000,
    AnnualRevenue = 10000000
);

String source = ' AccountNumber = "COIN" AND NumberOfEmployees < 10 OR AnnualRevenue < 1000000 ';
RF_SymTable symbolTable = new RF_SymTable('Account');
RF_Lex lex = new RF_Lex(symbolTable, source);
List<RF_Token> tokens = lex.scan();
System.debug(tokens);
symbolTable.print();
RF_Parse p = new RF_Parse(symbolTable, tokens, record);
RF_Value result = p.parse();
System.debug(result.toBooleanVal());


