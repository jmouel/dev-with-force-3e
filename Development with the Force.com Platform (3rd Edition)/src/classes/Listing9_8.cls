global class Listing9_8 implements Schedulable {
  global void execute(SchedulableContext sc) {
    Listing9_1 batch = new Listing9_1(); 
    Database.executeBatch(batch);
  }
}