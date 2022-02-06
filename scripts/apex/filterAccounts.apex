
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

String expression = ' (NumberOfEmployees > 1000 AND NumberOfEmployees < 20000) OR "Manufacturing" = Industry ';

RecordFilter rf = new RecordFilter('Account', expression);

for (Account account : accounts) {

    if (rf.match(account)) {
        System.debug('MATCH: ' + account.Name);
    }
}
// 09:18:36.61 (143684169)|USER_DEBUG|[33]|DEBUG|MATCH: Universal Containers
// 09:18:36.61 (147145571)|USER_DEBUG|[33]|DEBUG|MATCH: Acme Inc

