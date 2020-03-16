@isTest(SeeAllData=True)
public class AutoConvertLeadTest {

 static testMethod void validateAutoConvertLead() {
     Test.startTest();
     Lead testLead      = new lead();
     testLead.firstname = 'qasx';
     testLead.LastName  = 'Bucker';
     testLead.Company   =  'Not Applicable';
     testLead.LeadSource = 'Web';
     testLead.Pick_up_or_Drop_off__c = 'Pick Up';
     testLead.Type_of_Good__c = 'Meat';
     testLead.OwnerId   = Userinfo.getUserId();
     testLead.Status    = 'Convert Automation';
     insert testLead;

        test.stopTest();

 }
}