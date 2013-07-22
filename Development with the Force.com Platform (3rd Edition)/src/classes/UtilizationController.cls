public class UtilizationController {
  public Timecard__c card1 { get; private set; }
  public Timecard__c card2 { get; private set; }
  public Boolean shared { get; set; }
  public Decimal utilization { get; private set; }
  public Decimal totalHours { get; private set; }
  public Integer totalResources { get; private set; }
  public UtilizationController() {
    card1 = new Timecard__c();
    card2 = new Timecard__c();
  }
  public PageReference calculate() {
    Date startDate = card1.Week_Ending__c;
    Date endDate = card2.Week_Ending__c;
    // assumes all active resources are billable
    List<Contact> contacts = [ SELECT Id FROM Contact
      WHERE Active__c = TRUE AND Start_Date__c < :startDate ];
    List<Timecard__c> timecards = [ SELECT Week_Ending__c,
      Total_Hours__c FROM Timecard__c
      WHERE Billable__c = true AND
        Week_Ending__c >= :startDate AND
        Week_Ending__c <= :endDate
      ORDER BY Week_Ending__c ];
    totalHours = 0;
    if (timecards.size() == 0) {
      return null;
    }
    for (Timecard__c timecard : timecards) {
      totalHours += timecard.Total_Hours__c;
    }
    // adjust start and end dates to match timecard week endings
    Timecard__c firstTimecard = timecards.get(0);
    Timecard__c lastTimecard = timecards.get(timecards.size() - 1);
    if (startDate < firstTimecard.Week_Ending__c) {
      startDate = firstTimecard.Week_Ending__c.addDays(-6);
      card1.Week_Ending__c = startDate;
    }
    if (endDate > lastTimecard.Week_Ending__c) {
      endDate = lastTimecard.Week_Ending__c;
      card2.Week_Ending__c = endDate;
    }
    totalResources = contacts.size();
    Long availableHours = totalResources *
      calculateAvailableHours(startDate, endDate);
    utilization = 100 * totalHours.divide(availableHours, 2);
    if (shared) {
      shareUtilization();
    }
    return null;
  }
  public static Long calculateAvailableHours(
    Date startDate, Date endDate) {
    BusinessHours bh = [ SELECT id FROM BusinessHours
      WHERE IsDefault = true ];
    DateTime startTime = DateTime.newInstance(
      startDate.year(), startDate.month(), startDate.day(),
      0, 0, 0);
    DateTime endTime = DateTime.newInstance(
      endDate.year(), endDate.month(), endDate.day(),
      0, 0, 0);
    Decimal diff = Decimal.valueOf(
      BusinessHours.diff(bh.id, startTime, endTime));
    return diff.divide(3600000, 0).round();
  }
  private void shareUtilization() {
    BenchmarkWS.AnonymousBenchmark service =
      new BenchmarkWS.AnonymousBenchmark();
    BenchmarkWS.UtilizationEntry ue =
      new BenchmarkWS.UtilizationEntry();
    ue.naicsCode = '541511';
    ue.startDate = card1.Week_Ending__c;
    ue.endDate = card2.Week_Ending__c;
    ue.totalHours = totalHours;
    ue.totalResources = totalResources;
    ue.utilization = utilization;
    BenchmarkWS.SubmissionStatus[] results =
      service.submitUtilizationData(
        new BenchmarkWS.UtilizationEntry[] { ue });
    if (results != null) {
      for (BenchmarkWS.SubmissionStatus result : results) {
        if (!result.success) {
          ApexPages.addMessage(new ApexPages.Message(
            ApexPages.Severity.ERROR, result.errorMessage));
        } else {
          ApexPages.addMessage(new ApexPages.Message(
            ApexPages.Severity.INFO,
            'Shared anonymous benchmark data'));
        }
      }
    }
  }
}