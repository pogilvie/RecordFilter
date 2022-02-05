// RecordFilter rf = new RecordFilter(' 1 < 0 OR ( "B" > "A" AND 10 > 1) ');

List<Case>  cases = [SELECT Id, Origin, Subject, Type, Reason, Description FROM Case];


String expression = ' Origin = "Web" OR (Origin = "Email" AND Type = "Structural") ';

RecordFilter rf = new RecordFilter(expression);

for (Case cs : cases) {
    System.debug(
        String.format(
            '===> Subject: {0} match: {1}',
            new List<Object> { cs.Subject, rf.match(cs) }
        )
    );
}
