@IsTest
private class ProductServiceTest {
    @IsTest
    static void shouldReturnServiceName() {
        String result = ProductService.getServiceName();

        System.assertEquals('Mini Commerce Product Service', result);
    }
}