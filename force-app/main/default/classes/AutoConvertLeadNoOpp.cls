public class AutoConvertLeadNoOpp {
 @InvocableMethod
    public static void LeadAssign(List<Id> LeadIds)
    {
        LeadStatus CLeadStatus= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true Limit 1];
        List<Database.LeadConvert> MassLeadconvert = new List<Database.LeadConvert>();
        for(id currentlead: LeadIds){
                Database.LeadConvert Leadconvert = new Database.LeadConvert();
                Leadconvert.setLeadId(currentlead);
            	Leadconvert.setDoNotCreateOpportunity(True);
                Leadconvert.setConvertedStatus(CLeadStatus.MasterLabel);
                MassLeadconvert.add(Leadconvert);
        }
        List<ID> LeadAccounts      = new List<ID>();
        if (!MassLeadconvert.isEmpty()) {
            for(Database.leadconvert acc : MassLeadConvert){
                Database.LeadConvertResult art = database.convertlead(acc); 
                LeadAccounts.add(art.getAccountId());
        }
            List<Account> LeadAccountsupdate = [Select ID, name, Rejected_Donation__c, npe01__One2OneContact__c,(Select FirstName, Lastname, AccountId, ID  from Contacts Limit 1) From Account Where ID in :LeadAccounts];
            for(Account acc: LeadAccountsupdate){
                acc.name = acc.contacts[0].firstname + ' ' + acc.contacts[0].lastname + ' Household';
                acc.npe01__One2OneContact__c = acc.contacts[0].id;
                acc.Rejected_Donation__c    = True;
                update acc;
            }
    }
}
}