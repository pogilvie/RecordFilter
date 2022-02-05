List<Account> accounts = [SELECT Id, Name, NumberOfEmployees FROM Account];

Sobject record = accounts[0];

Object value = record.get('NumberOfEmployees');

System.debug('As String: ' + String.valueOf(value));
// System.debug('As Number: ' + Decimal.valueOf(value));
