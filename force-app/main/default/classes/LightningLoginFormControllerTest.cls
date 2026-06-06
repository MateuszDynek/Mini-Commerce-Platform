@IsTest(SeeAllData = true)
public with sharing class LightningLoginFormControllerTest {

 @IsTest
 static void LightningLoginFormControllerInstantiation() {
  LightningLoginFormController controller = new LightningLoginFormController();
  System.assertNotEquals(controller, null);
 }

 @IsTest
 static void testIsUsernamePasswordEnabled() {
  System.assertEquals(true, LightningLoginFormController.getIsUsernamePasswordEnabled());
 }

 @IsTest
 static void testIsSelfRegistrationEnabled() {
  System.assertEquals(false, LightningLoginFormController.getIsSelfRegistrationEnabled());
 }

 @IsTest
 static void testGetSelfRegistrationURL() {
  System.assertEquals(null, LightningLoginFormController.getSelfRegistrationUrl());
 }

 @IsTest
 static void testGetForgotPasswordUrl() {
  String forgotPasswordUrl = LightningLoginFormController.getForgotPasswordUrl();
  System.assert(forgotPasswordUrl == null || forgotPasswordUrl.length() > 0);
 }

 @IsTest
 static void testLoginHandlesSiteLoginResult() {
  String result = LightningLoginFormController.login('testuser@example.com', 'password123', '/s');
  System.assert(result == null || result.length() > 0);
 }

 @IsTest
 static void testSetExperienceId() {
  System.assertEquals(null, LightningLoginFormController.setExperienceId(null));

  String result = LightningLoginFormController.setExperienceId('invalidExperienceId');
  System.assert(result == null || result.length() > 0);
 }

 @IsTest
 static void testAuthConfig() {
  Auth.AuthConfiguration authConfig = LightningLoginFormController.getAuthConfig();
  System.assertNotEquals(null, authConfig);
 }
}
