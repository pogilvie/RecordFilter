
Case cs = [SELECT Id, Subject, Origin FROM Case];

SObjectType type = cs.getSObjectType();

System.debug(JSON.serializePretty(type.getDescribe()));

Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Case.fields.getMap();


Schema.SObjectField T = fieldMap.get('Origin');
Schema.DescribeFieldResult F = T.getDescribe();
Schema.DisplayType type = F.getType();

SObjectType accountType = Schema.getGlobalDescribe().get('Account');
Map<String,Schema.SObjectField> mfields = accountType.getDescribe().fields.getMap();

// address	Address values
// anytype	Any value of the following types: String, Picklist, Boolean, Integer, Double, Percent, ID, Date, DateTime, URL, or Email.
// base64	Base64-encoded arbitrary binary data (of type base64Binary)
// Boolean	Boolean (true or false) values
// Combobox	Comboboxes, which provide a set of enumerated values and allow the user to specify a value not in the list
// Currency	Currency values
// DataCategoryGroupReference	Reference to a data category group or a category unique name
// Date	Date values
// DateTime	DateTime values
// Double	Double values
// Email	Email addresses
// EncryptedString	Encrypted string
// ID	Primary key field for an object
// Integer	Integer values
// Location	Location values, including latitude and longitude.
// Long	Long values
// MultiPicklist	Multi-select picklists, which provide a set of enumerated values from which multiple values can be selected
// Percent	Percent values
// Phone	Phone numbers. Values can include alphabetic characters. Client applications are responsible for phone number formatting.
// Picklist	Single-select picklists, which provide a set of enumerated values from which only one value can be selected
// Reference	Cross-references to a different object, analogous to a foreign key field
// String	String values
// TextArea	String values that are displayed as multiline text fields
// Time	Time values
// URL	URL values that are displayed as hyperlinks