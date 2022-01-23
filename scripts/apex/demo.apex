
String source = 'x = (6 + 2) * 3';
RF_Lex lex = new RF_Lex(source);
List<RF_Token> tokens = lex.scann();
Demo demo = new Demo(tokens);
demo.parse();