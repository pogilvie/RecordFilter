
String s = '()!<>=+-*/';
Integer[] characters = s.getChars();
characters.add(0);

for (Integer i = 0; i < characters.size(); i++) {
    System.debug(String.format('index:{0} char:{1} value:{2}', new List<Object> {
        i, String.fromCharArray(new List<Integer> { characters[i] }), characters[i]
    }));
}
