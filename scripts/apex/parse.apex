
List<Case>  cases = [SELECT Id, Subject, Description FROM Case];

Case cs = cases[0];

RecordFilter rf = new RecordFilter('1 > 2 OR true');
System.debug(rf.match(cs));
