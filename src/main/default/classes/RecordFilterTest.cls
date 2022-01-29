@isTest class RecordFilterTest {

    @testSetup static void setup() {
        insert new Case(
            Subject = 'Hello, World!',
            Origin = 'Web',
            Description = 'this is a long text area'
        );
    }

    static Case getData() {
        return [SELECT Id, Subject, Origin, Description FROM Case];
    }

    @isTest static void simple() {
        Case cs = getData();

        RecordFilter rf = new RecordFilter('true AND true');
        System.assert(rf.match(cs));
        
        rf =  new RecordFilter('true OR false');
        System.assert(rf.match(cs));
        
        rf = new RecordFilter('true AND true AND (true OR false)');
        System.assert(rf.match(cs));
        
        rf = new RecordFilter('1 > 2 OR true');
        System.assert(rf.match(cs));

    }
}
