
## SBoolExpresion
Evaluate a boolean expression which can be stored in custom metadata.  The
œexpressionœœœ evaluates to true record matches the filter false otherwise

## Example 

Given a collection of Salesforce record of the same SObject
Create a new field on a custom metadata object

Trigger_Action__md.filter__c of type long text area

```
    RecordType = 'Support' AND
    Origin = 'Web' AND
    ISCHANGED(SuppliedEmail)
```
Where Origin and SupppliedEmail are fields on the Case SObject.  RecordType is a
psuedofield which resovled to the Name of the Case record type assocated with
the RecordTypeId field.  This expression will return true if the SuppliedEmail
field of the target record is had been updated.

Use of this facility is planned in conjection with the trigger action framework
to save the cost of invoking flow action for records in which the flow is not
targeted.

## Grammer †
(borrowed / copied from lox () Robert Nystrom)

<expression> --> <term> ( ('AND'|'OR') <term> )*
<term> --> <comparison> ( ('='|'!='|'<'|''>'|'<='|>=) <comparison> )*
<comparison> --> ID | CONST | STR'(' <expression> ')'
terminals { ID, CONST, '"'string'"', '(', ')' }

RecordType = 'Support

† Missing built in support in the example above
  

