public class MyPageController7_1 {
  public Integer value { get; private set; }
  public Integer amount { get; set; }
  public MyPageController7_1() {
    value = 0;
  }
  public PageReference increment() {
    value += amount;
    return null;
  }
}