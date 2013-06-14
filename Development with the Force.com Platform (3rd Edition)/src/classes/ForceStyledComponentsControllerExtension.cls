public class ForceStyledComponentsControllerExtension {
  private final List<Contact> contacts;
  public ForceStyledComponentsControllerExtension(
    ApexPages.StandardSetController stdController) {
    this.contacts = (List<Contact>)stdController.getRecords();
  }
  public PageReference initPage() {
    ApexPages.addMessage(new ApexPages.Message(
      ApexPages.Severity.INFO, 'pageMessages'));
    return null;
  }
}