
@isTest
private class TempClassTest {

    @isTest
    static void getTempClassNameTest() {
        Test.startTest();
        String lel = TempClass.getTempClassName();
        Test.stopTest();
        System.assertEquals(lel, 'TempClass');
    }
}