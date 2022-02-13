@isTest class RF_ParseTest {

    @isTest static void operatorCoverage() {
        Account account = new Account(
            Name = 'Universal Containers',
            NumberOfEmployees = 12500,
            AnnualRevenue = 1000000000.0,
            TickerSymbol = 'UNCO',
            Industry = 'Shipping'
        );

        // number = operator
        String expression = ' NumberOfEmployees = 12500 ';
        RecordFilter rf = new RecordFilter('Account', expression);
        System.assert(rf.match(account), expression);

        // number != operator
        expression = ' NumberOfEmployees != 10000 ';
        rf = new RecordFilter('Account', expression);
        System.assert(rf.match(account), expression);

        // number < operator
        expression = ' NumberOfEmployees < 20000 ';
        rf = new RecordFilter('Account', expression);
        System.assert(rf.match(account), expression);

        // string < operator
        expression = ' Name < "Zoro" ';
        rf = new RecordFilter('Account', expression);
        System.assert(rf.match(account), expression);

        // string > operator
        expression = ' Name > "Abba" ';
        rf = new RecordFilter('Account', expression);
        System.assert(rf.match(account), expression);

        // number <= operator
        expression = ' NumberOfEmployees <= 12500 ';
        rf = new RecordFilter('Account', expression);
        System.assert(rf.match(account), expression);
       
        // number <= operator
        expression = ' NumberOfEmployees >= 12500 ';
        rf = new RecordFilter('Account', expression);
        System.assert(rf.match(account), expression);

        // string <= operator
        expression = ' Name <=  "Universal Containers" ';
        rf = new RecordFilter('Account', expression);
        System.assert(rf.match(account), expression);

        // string >= operator
        expression = ' Name >=  "Universal Containers" ';
        rf = new RecordFilter('Account', expression);
        System.assert(rf.match(account), expression);

    }

   /*
    * GIVEN: The parser has a recursion check at 15 levels of recursion and that
    *        '(' triggers and recursive call 
    * EXPECT: That heavy nesting of parentheses will trigger an recursion detected
    *          exception
    */
    @isTest static void verifyRecursionCheck() {

        Boolean hitException = false;

        Account account = new Account(
            Name = 'Universal Containers',
            NumberOfEmployees = 12500,
            AnnualRevenue = 1000000000.0,
            TickerSymbol = 'UNCO',
            Industry = 'Shipping'
        );
        String expression = ' TickerSymbol = "UNCO" AND ((((((((((((((((( TickerSymbol != "CRM" ))))))))))))))))) ';

        RecordFilter rf = new RecordFilter('Account', expression);

        try {
            rf.match(account);
        } catch(RF_Parse.RF_ParseException e) {
            System.assert(e.getMessage().contains('recursion'));
            hitException = true;
        }

        System.assert(hitException);
    }

}
