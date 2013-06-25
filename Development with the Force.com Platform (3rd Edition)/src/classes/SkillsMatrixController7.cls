public class SkillsMatrixController7 {
  public String selectedContactId { get; set; }
  public Boolean isEditable { get; private set; }
  public Contact selectedContact { get; private set; }
  public List<Skill__c> selectedSkills { get; private set; }
  public String selectedSkillType { get; set; }
  public List<SelectOption> getContactOptions() {
    List<SelectOption> options = new List<SelectOption>();
      options.add(new SelectOption(
        '', '-- Select Contact --'));
    List<Contact> contacts = [ SELECT Id, Name
      FROM Contact ORDER BY LastName ];
    for (Contact contact : contacts) {
      options.add(new SelectOption(contact.Id,
        contact.Name));
    }
    return options;
  }
  public PageReference refresh() {
    if (selectedContactId == null) {
      addError('Select a contact');
      return null;
    }
    selectedContact = [ SELECT Id, Name,
      User__r.UserRoleId,
      User__r.ProfileId,
      (SELECT Type__c, Rating__c, LastModifiedDate
        FROM Skills__r ORDER BY Rating__c DESC)
      FROM Contact
      WHERE Id = :selectedContactId
      LIMIT 1 ];
    Set<String> skillTypes = new Set<String>();
    selectedSkills = new List<Skill__c>();
    for (Skill__c skill : selectedContact.Skills__r) {
      skillTypes.add(skill.Type__c);
      selectedSkills.add(skill);
    }
    Schema.DescribeFieldResult field = Skill__c.Type__c.getDescribe();
    String picklistValue = null;
    for (Schema.PicklistEntry entry : field.getPicklistValues()) {
      picklistValue = entry.getLabel();
      if (!skillTypes.contains(picklistValue)) {
        selectedSkills.add(
          new Skill__c(Contact__c = selectedContact.Id,
            Type__c = picklistValue));
      }
    }
    if (isManager()) {
      isEditable = true;
    } else {
      Contact userContact = getCurrentUserContact();
      isEditable =
        selectedContact != null && userContact != null
        && selectedContact.Id == userContact.Id;
    }
    return null;
  }
  private void addError(String msg) {
    ApexPages.addMessage(new ApexPages.Message(
      ApexPages.Severity.ERROR, msg));
  }
  private void addInfo(String msg) {
    ApexPages.addMessage(new ApexPages.Message(
      ApexPages.Severity.INFO, msg));
  }
  public Contact getCurrentUserContact() {
    List<Contact> userContact = [ SELECT Id, Name,
      User__r.UserRoleId, User__r.ProfileId
      FROM Contact
      WHERE User__c = :UserInfo.getUserId()
      LIMIT 1 ];
    if (userContact.size() == 0) {
      addError('No contact associated with user');
      return null;
    } else {
      return userContact.get(0);
    }
  }
  private Boolean isManager() {
    List<Profile> profiles = [ SELECT Id
      FROM Profile WHERE Name IN (
      'Project Manager', 'Vice President', 'System Administrator')
      AND Id = :UserInfo.getProfileId() LIMIT 1 ];
    return profiles.size() == 1;
  }
  public PageReference save() {
    try {
      upsert selectedSkills;
      addInfo('Changes saved');
    } catch(DmlException e) {
      addError('Could not save changes: ' + e.getMessage());
    }
    return null;
  }
  public PageReference refreshCompareSkills() {
   return null;
  } 
}