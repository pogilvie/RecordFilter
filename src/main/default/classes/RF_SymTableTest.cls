@isTest class RF_SymTableTest {

    /*
     *  GIVEN: an sObjectName of Account
     *  EXPECT:
     *  1. A field with the name "Name" can be added to the symbol table
     *  2. A field with the name "NumberOfEmployees" can be added to the symbol table
     *  3. A field with the name "AnnualRevenue" can be added to the symbol table 
     *  4. A symbol table lookup with key "Name" returns value STR
     *  5. A symbol table lookup with key "NumberOfEmployees" (Integer field) returns value NUM
     *  6. A symbol table lookup with key "AnnualRevenue" (currency field) returns value NUM
     */
    @isTest static void verify() {
        RF_SymTable symbolTable = new RF_SymTable('Account');

        symbolTable.add('Name');                                // AC 1 
        symbolTable.add('NumberOfEmployees');                   // AC 2
        symbolTable.add('AnnualRevenue');                       // AC 3

        Rf_Value.Type type = symbolTable.get('Name');
        System.AssertEquals(RF_Value.Type.STR, type);           // AC 4

        type = symbolTable.get('NumberOfEmployees');
        System.AssertEquals(RF_Value.Type.NUM, type);           // AC 5
        
        type = symbolTable.get('AnnualRevenue');
        System.AssertEquals(RF_Value.Type.NUM, type);           // AC 6
    }

    /*
     * GIVEN: An SObject name which does not exist in the system
     * EXPECT: An exception will be thrown when an attempt is made to create a
     * symbol table with this name
     */
    @isTest static void badObject() {
        Boolean hitException = false;

        try {
            new RF_SymTable('Foo');
        } catch (Exception e) {
            hitException = true;
        }

        System.assert(
            hitException, 
            'Expect exception when an attempt is made to create a symbol table for an SObject which does not exist in the system'
        );
    }

    /*
     * GIVEN: A symbol table for the Account Sobject
     * EXPECT: 
     * 1. An exception will be thrown when an attempt is made to add a
     *    field which does not exist on the Account Sobject
     * 2. An exception will be thrown when an attempt is made is lookup a field
     *    which is not in the symbol table 
     */
    @isTest static void badField() {
        RF_SymTable symbolTable = new RF_SymTable('Account');
        Boolean hitExceptionOnAdd = false;
        Boolean hitExceptionOnGet = false;

        try {
            symbolTable.add('foo');
        } catch (Exception e) {
            hitExceptionOnAdd = true;
        }

        try {
            symbolTable.get('foo');
        } catch (Exception e) {
            hitExceptionOnGet = true;
        }

        System.assert(
            hitExceptionOnAdd, 
            'Expeption expected when attempt to ADD an invalid field to a symbol table'
        );

        System.assert(
            hitExceptionOnGet, 
            'Expeption expected when attempt to GET an invalid field to a symbol table'
        );
    }

}
