Account account = new Account(
    Name = 'Universal Containers',
    NumberOfEmployees = 12500,
    AnnualRevenue = 1000000000.0,
    TickerSymbol = 'UNCO',
    Industry = 'Shipping'
);

RecordFilter rf = new RecordFilter('Account', 'TickerSymbol != null');
System.debug(rf.match(account));