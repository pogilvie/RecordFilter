
List<Account> accounts = [SELECT Id, Name, NumberOfEmployees FROM Account];

String expression = ' NumberOfEmployees > 10 ';

RecordFilter rf = new RecordFilter(expression);

for (Account a : accounts) {
    System.debug(
        String.format(
            '===> Subject: {0} match: {1}',
            new List<Object> { a.Name, rf.match(a) }
        )
    );
}