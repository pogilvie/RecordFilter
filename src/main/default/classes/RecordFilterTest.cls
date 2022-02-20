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

    /* 
     * NOT Operator (!)
     */
    @isTest static void verifyNot() {

        List<Account> accounts = new List<Account> {
            new Account(
                Name = 'Universal Containers',
                NumberOfEmployees = 12500,
                AnnualRevenue = 1000000000.0,
                TickerSymbol = 'UNCO',
                Industry = 'Shipping'
            ),
            new Account(
                Name = 'Salesforce',
                NumberOfEmployees = 29000,
                AnnualRevenue = 6000000000.0,
                TickerSymbol = 'CRM',
                Industry = 'Technology'
            ),
            new Account(
                Name = 'Acme Inc',
                NumberOfEmployees = 100,
                AnnualRevenue = 1000000,
                TickerSymbol = 'ACME',
                Industry = 'Manufacturing'
            )
        };

        String expression = ' AnnualRevenue > 1000 AND !(Name = "Universal Containers" OR Name = "Salesforce") ';

        RecordFilter rf = new RecordFilter('Account', expression);

        for (Account account : accounts) {

            if (rf.match(account)) {
                System.assertEquals('Acme Inc', account.Name);
            }
        }
    }

    @isTest static void invalidField() {
        Boolean hitException = false;

        Account account = new Account(
            Name = 'Universal Containers',
            NumberOfEmployees = 12500,
            AnnualRevenue = 1000000000.0,
            TickerSymbol = 'UNCO',
            Industry = 'Shipping'
        );

        String expression = ' Foo > 1000 ';


        try {
            RecordFilter rf = new RecordFilter('Account', expression);
            rf.match(account);
        } catch(RF_SymTable.RF_SymTableException e) {
            hitException = true;
        }

        System.assert(hitException, 'invalid field should throw exception');

    }

    @isTest static void illegalNot() {
        Boolean hitException = false;

        Account account = new Account(
            Name = 'Universal Containers',
            NumberOfEmployees = 12500,
            AnnualRevenue = 1000000000.0,
            TickerSymbol = 'UNCO',
            Industry = 'Shipping'
        );

        String expression = ' !TickerSymbol ';

        try {
            RecordFilter rf = new RecordFilter('Account', expression);
            rf.match(account);  
        } catch(RF_Parse.RF_ParseException e) {
            hitException = true;
        }

        System.assert(hitException, 'Excepting NOT (!) opererator exception');
    }

    @isTest static void missingRightParen() {
        Boolean hitException = false;

        Account account = new Account(
            Name = 'Universal Containers',
            NumberOfEmployees = 12500,
            AnnualRevenue = 1000000000.0,
            TickerSymbol = 'UNCO',
            Industry = 'Shipping'
        );

        String expression = ' (TickerSymbol = "UNCO ';

        try {
            RecordFilter rf = new RecordFilter('Account', expression);
            rf.match(account);  
        } catch(RF_Parse.RF_ParseException e) {
            hitException = true;
        }

        System.assert(hitException, 'Excepting NOT (!) opererator exception');
    }
    
    @isTest static void nullValue() {
        Account account = new Account(
            Name = 'Universal Containers',
            NumberOfEmployees = 12500,
            AnnualRevenue = 1000000000.0,
            TickerSymbol = 'UNCO',
            Industry = 'Shipping'
        );

        RecordFilter rf = new RecordFilter('Account', 'Phone = null');
        System.assert(rf.match(account));

        rf = new RecordFilter('Account', 'TickerSymbol != null');
        System.assert(rf.match(account));

        Boolean hitException = false;
        try {
            rf = new RecordFilter('Account', 'TickerSymbol < null');
            rf.match(account);
        } catch (RF_Parse.RF_ParseException e) {
            hitException = true;
        }
        System.assert(hitException);

        hitException = false;
        try {
            rf = new RecordFilter('Account', 'TickerSymbol > null');
            rf.match(account);
        } catch (RF_Parse.RF_ParseException e) {
            hitException = true;
        }
        System.assert(hitException);
        
        hitException = false;
        try {
            rf = new RecordFilter('Account', 'TickerSymbol <= null');
            rf.match(account);
        } catch (RF_Parse.RF_ParseException e) {
            hitException = true;
        }
        System.assert(hitException);

        hitException = false;
        try {
            rf = new RecordFilter('Account', 'TickerSymbol >= null');
            rf.match(account);
        } catch (RF_Parse.RF_ParseException e) {
            hitException = true;
        }
        System.assert(hitException);
    }


}
