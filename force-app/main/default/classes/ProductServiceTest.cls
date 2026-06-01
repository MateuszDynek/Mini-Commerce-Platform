@IsTest
private class ProductServiceTest {
    @IsTest
    static void shouldReturnServiceName() {
        String result = ProductService.getServiceName();

        System.assertEquals('Mini Commerce Product Service', result);
    }

    @IsTest
    static void shouldReturnVersion() {
        String result = ProductService.getVersion();

        System.assertEquals('2.0.0', result);
    }
}