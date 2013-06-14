public class MyPageController6_6 {
  public List<ContactWrapper> contacts { get; set; }
  public MyPageController6_6() {
    contacts = new List<ContactWrapper>();
    List<Contact> records = [ SELECT Name FROM Contact ];
    for (Contact record : records) {
      contacts.add(new ContactWrapper(record));
    }
  }
  public PageReference doSomething() {
    for (ContactWrapper wrapper : contacts) {
      if (wrapper.selected) {
        System.debug(wrapper.data.Id);
      }
    }
    return null;
  }
  class ContactWrapper {
    public Contact data { get; private set; }
    public Boolean selected { get; set; }
    public ContactWrapper(Contact data) {
      this.data = data;
      this.selected = false;
    }
  }
}