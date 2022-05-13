@isTest private class CaseClassHelperTest {
    @isTest static void testClass(){
        CaseClassHelper obj = new CaseClassHelper();
        obj.firstName = 'Alberto';
        obj.lastName = 'Campos';
        obj.phone = '7771585683';
        obj.email = 'sr.albertocampos@gmail.com';
        obj.SKU = 'HDJU7T5RD3';
        obj.subject = 'This is a test';
        obj.description = 'Just a simple test';
        obj.street = 'Av Morelos';
        obj.city = 'Cuernavaca';
        obj.country = 'Mexico';
        obj.province = 'Morelos';
        obj.postalCode = '62039';

        String json = JSON.serialize(obj);
        CaseClassHelper jsonObj = CaseClassHelper.parse(json);

        System.assertEquals(obj.firstName, jsonObj.firstName, 'Same');
    }
}
