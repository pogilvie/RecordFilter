public with sharing class RF_Stack {

    List<RF_Value> stack = new List<RF_Value>();

    public void push(RF_Value element) {
            stack.add(element);
    }

    public RF_Value pop() {
        if (!stack.isEmpty()) {
            return stack.remove(stack.size() - 1);
        } else {
            return null;
        }
    }

    public void print() {
        System.debug('*** TOP OF STACK ***');
        for (Integer i = stack.size() - 1; i >= 0; i--) {
            System.debug(stack[i]);
        }
        System.debug(('*** PRINT STACK DONE ***'));
    }
}
