public with sharing class SignupController {
  public Lead lead { get; set; }
  public SignupController() {
  	lead = new Lead(LastName = '[Not provided]',
  	  Company = '[Not provided]');
  }
  public PageReference submit() {
  	if (lead.EMail == null || lead.EMail.trim().length() == 0) {
      return invalid();
  	}
    try {
      insert lead;
      CampaignMember member = new CampaignMember(
      	CampaignId = '701i00000005ZEN',
      	LeadId = lead.Id);
      insert member;
    } catch(Exception ex) {
      return invalid();
    }
  	return success();
  }

  private static PageReference invalid() {
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
      'Please enter a valid e-mail address'));
    return null;
  }
  
  private static PageReference success() {
  	PageReference ref = Page.SignupSuccess;
  	ref.setRedirect(true);
  	return ref;
  }
}