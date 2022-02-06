
## RecordFilter
Record filter is an SObject aware tiny expression language and parser.
Expressions written in RecordFilter can be stored in custom metadata text fields
declaratively and evaluated at runtime against record collections in situations
where making filter criteria configurable are desirable.

A use case might be the implementation of guard filter criteria on Flow and Apex
actions written using the [Trigger Action
Framework](https://github.com/mitchspano/apex-trigger-actions-framework).  A
filter expression could be added to the metadata record declaratively.   The
framework could be updated to only pass records to the action which meets the
criteria specified in the RecordFilter expression.

## Example 

```
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
```

A few things to notice about RecordFilter expressions:
- Parentheses are supported to arbitrary nesting depth to support grouping of
  logical operators
- The RecordFilter lexer understands the difference between identifiers, strings and numbers
- The RecordFilter parser understands that identifiers are Salesforce sObject
  fields and understands what comparison types are legal for those field types
- RecordFilter implements a context free grammar so identifiers don't have to be
  on the left side of an expression to be understood. ( "Manufacturing" = Industry)

## Installation

### Install unlocked package via Salesforce installer
 [RecordFilter@1.0.0-1](https://login.salesforce.com/packaging/installPackage.apexp?p0=04t4N000000GkX5QA)

### Install to a scatch org from source

Set the environment variable `DEVHUB` to the user name or alias of your Salesforce CLI authenticated devhub.   The build environment uses the Unix make utility, so that needs to be installed.

```
% git clone https://github.com/pogilvie/RecordFilter.git
% cd RecordFilter
% export DEVHUB='myDevHUbAlias'
% make scratch
% make # this will push the source to a the newly minted scatch org
```

### Install to a sandbox from source
```
% git clone https://github.com/pogilvie/RecordFilter.git
% cd RecordFilter
% export installTarget='mySandboxAlias'
% make -e # remember the -e here
```

### Install from the CLI to developer org, production org org sandbox
```
% git clone https://github.com/pogilvie/RecordFilter.git
% cd RecordFilter
% export installTarget='mySandboxAlias'
% make -e install
```
## Grammar
(Adapted from Lox language by Robert Nystrom)

```
<expression> --> <term> ( ('AND'|'OR') <term> )*
<term> --> <comparison> ( ('='|'!='|'<'|''>'|'<='|>=) <comparison> )*
<comparison> --> IDENTIFER | DECIMAL_NUMBER | STRING'(' <expression> ')'
terminals { IDENTIFIER, CONST, '"'STRING'"', '(', ')' }
```

## Limitations of the Release 1.0
- Not operator is not supported  (This is on the short list for 1.1)
- Date / Datetime types are not supported by the lexer
- No support for useful built-in operations: For example the operator
  IsNew (<field>) would allow filtering a list of records by records where the
  value of a field had changed.
  

