@isTest class RecordFilterTest {

    @testSetup static void setup() {
        insert new List<Case>  {
            new Case(
               Subject = 'Hello, World!',
               Origin = 'Web',
               Type = 'Electronic',
               Reason = 'Breakdown',
               Description = 'this is a long text area'
           ),
           new Case(
                Subject = 'Case Two',
                Origin = 'Email',
                Type = 'Mechanical',
                Reason = 'Breakdown',
                Description = 'this is case two'
           ),
           new Case(
                Subject = 'Case Three',
                Origin = 'Web',
                Type = 'Mechanical',
                Reason = 'Structural',
                Description = 'this is case three'
           )
        };
    }

    static List<Case> getData() {
        return [SELECT Id, Subject, Origin, Type, Reason, Description FROM Case];
    }

    static Case getOne() {
        return [SELECT Id, Subject, Origin, Description FROM Case WHERE Subject = 'Hello, World!'];
    }

    @isTest static void positive() {
        Case cs = getOne();

        RecordFilter rf = new RecordFilter('Case', 'true AND true');
        System.assert(rf.match(cs));
        
        rf =  new RecordFilter('Account', 'true OR false');
        System.assert(rf.match(cs));
        
        rf = new RecordFilter('Account', 'true AND true AND (true OR false)');
        System.assert(rf.match(cs));
        
        rf = new RecordFilter('Account', '1 > 2 OR true');
        System.assert(rf.match(cs));

    }

    @isTest static void negative() {
        Boolean hitException = false;

        Case cs = getOne();

        try {
            RecordFilter rf = new RecordFilter('Account', '1 > "hello" ');
            System.assert(rf.match(cs));
        } catch (RF_Parse.RF_ParseException e) {
            hitException = true;
        }
        System.assert(hitException);  
    }

    @isTest static void strings() {
        Case cs = getOne();
        RecordFilter rf = new RecordFilter('Account', ' "hello" = "hello" ');
        System.debug(rf.match(cs));

        rf = new RecordFilter('Account', ' "hello" != "world" ');
        System.debug(rf.match(cs));
    }

    @isTest static void verifyRecord() {
        List<Case> cases = getData();

        RecordFilter rf = new RecordFilter(
            'Case', ' Origin = "Web" AND Type = "Mechanical" '
        );

        for (Case cs : cases) {
            System.debug(String.format('Subject: {0} match: {1}', new List<Object> {
                cs.Subject,
                rf.match(cs)
            }));
        }
    }
}
