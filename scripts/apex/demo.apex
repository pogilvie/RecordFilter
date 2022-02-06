
String source = 'x = (1 + 2) * 3 * 4';
RF_Lex lex = new RF_Lex(source);
List<RF_Token> tokens = lex.scan();
Demo demo = new Demo(tokens);
demo.parse();