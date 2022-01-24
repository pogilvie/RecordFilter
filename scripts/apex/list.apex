List<String> colors = new List<String> {
    'red', 'green', 'blue'
};

String red = colors.remove(0);
System.debug(red);
System.debug(colors);
colors.add(0, 'black');
System.debug(colors);

List<String> empty = new List<String>();

for (Integer i = empty.size() - 1; i >= 0; i--) {
    System.debug(empty[i]);
}
