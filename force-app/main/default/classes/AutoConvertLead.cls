Public class AutoConvertLead
{
    @InvocableMethod
    public static void LeadAssign(List<Id> LeadIds)
    {
        LeadStatus CLeadStatus= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true Limit 1];
        List<Database.LeadConvert> MassLeadconvert = new List<Database.LeadConvert>();
        for(id currentlead: LeadIds){
                Database.LeadConvert Leadconvert = new Database.LeadConvert();
                Leadconvert.setLeadId(currentlead);
            	Leadconvert.setOwnerId(Userinfo.getUserId());
                Leadconvert.setConvertedStatus(CLeadStatus.MasterLabel);
                MassLeadconvert.add(Leadconvert);
        }
        List<ID> LeadAccounts      = new List<ID>();
        List<ID> LeadOpportunities = new List<ID>();
        if (!MassLeadconvert.isEmpty()) {
            for(Database.leadconvert acc : MassLeadConvert){
                Database.LeadConvertResult art = database.convertlead(acc); 
                LeadAccounts.add(art.getAccountId());
                LeadOpportunities.add(art.getOpportunityId());
                
        }
            List<Account> LeadAccountsupdate = [Select ID, name, npe01__One2OneContact__c,(Select FirstName, Lastname, AccountId, ID  from Contacts Limit 1) From Account Where ID in :LeadAccounts];
            System.debug(LeadAccountsupdate.size());
            for(Account acc: LeadAccountsupdate){
                System.debug(acc.contacts[0]);
                acc.name = acc.contacts[0].firstname + ' ' + acc.contacts[0].lastname + ' Household';
                acc.npe01__One2OneContact__c = acc.contacts[0].id;
                update acc;
            }
            List<Opportunity> LeadOpportunitiesupdate = [Select ID, Name, npsp__Primary_Contact__c, Pick_up__c, Type_of_Good__c, Closedate, account.npe01__One2OneContact__r.name From Opportunity Where ID in :LeadOpportunities];
            for(Opportunity opp: LeadOpportunitiesupdate){
                String[] multi = opp.Type_of_Good__c.split(';');
                String   rcc   = string.valueof(opp.CloseDate);
                opp.name = opp.account.npe01__One2OneContact__r.name + ' / ' + opp.Pick_up__c + ' / ' + multi + ' / ' + rcc; 
                opp.npsp__Primary_Contact__c =  opp.account.npe01__One2OneContact__c;
                update opp;  
    }
}
}
}