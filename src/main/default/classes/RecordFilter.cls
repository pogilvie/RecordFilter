public class RecordFilter {
    
    public static void error(Integer line, String msg) {
        System.debug(String.format(
            'Error Line {0}: {1}',
            new List<Object> { line, msg }
        ));
    }
    
    public Boolean match(String formula) {
        return true;
    }
}
