
List<Case>  cases = [SELECT Id, Origin, Subject, Description FROM Case];

Case cs = cases[0];

RecordFilter rf = new RecordFilter(' Origin = "Email" ');
System.debug(rf.match(cs));
