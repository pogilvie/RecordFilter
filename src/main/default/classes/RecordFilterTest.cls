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

    @isTest static void positive() {
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

    @isTest static void negative() {
        Boolean hitException = false;

        Case cs = getData();

        try {
            RecordFilter rf = new RecordFilter('1 > "hello" ');
            System.assert(rf.match(cs));
        } catch (RF_Parse.RF_ParseException e) {
            hitException = true;
        }
        System.assert(hitException);  
    }

    @isTest static void strings() {
        Case cs = getData();
        RecordFilter rf = new RecordFilter(' "hello" = "hello" ');
        System.debug(rf.match(cs));

        rf = new RecordFilter(' "hello" != "world" ');
        System.debug(rf.match(cs));
    }
}
