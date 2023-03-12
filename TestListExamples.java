import static org.junit.Assert.*;
import org.junit.*;
import java.util.Arrays;
import java.util.List;

class IsMoon implements StringChecker {
  public boolean checkString(String s) {
    return s.equalsIgnoreCase("moon");
  }
}

public class TestListExamples {
  //Testing filter
  @Test(timeout = 500)
  public void testFilterAllFalse() {
    List<String> input = Arrays.asList("sun", "stars", "galaxy");
    List<String> expected = Arrays.asList();
    List<String> filtered = ListExamples.filter(input, new StringChecker() {
      public boolean checkString(String s) {
        return false;
      }
    });
    assertEquals(expected, filtered);
  }

  @Test(timeout = 500)
  public void testFilterAllTrue() {
    List<String> input = Arrays.asList("sun", "stars", "galaxy");
    List<String> expected = Arrays.asList("sun", "stars", "galaxy");
    List<String> filtered = ListExamples.filter(input, new StringChecker() {
      public boolean checkString(String s) {
        return true;
      }
    });
    assertEquals(expected, filtered);
  }

  @Test(timeout = 500)
    public void testFilterEmptyList() {
    List<String> input = Arrays.asList();
    List<String> expected = Arrays.asList();
    List<String> filtered = ListExamples.filter(input, new IsMoon());
    assertEquals(expected, filtered);
  }

  @Test(timeout = 500)
  public void testFilterNoMatches() {
    List<String> input = Arrays.asList("sun", "stars", "galaxy");
    List<String> expected = Arrays.asList();
    List<String> filtered = ListExamples.filter(input, new IsMoon());
    assertEquals(expected, filtered);
  }

  @Test(timeout = 500)
  public void testFilterAllMatches() {
    List<String> input = Arrays.asList("moon", "Moon", "mOoN");
    List<String> expected = Arrays.asList("moon", "Moon", "mOoN");
    List<String> filtered = ListExamples.filter(input, new IsMoon());
    assertEquals(expected, filtered);
  }

  @Test(timeout = 500)
  public void testFilterSomeMatches() {
    List<String> input = Arrays.asList("sun", "moon", "stars", "Moon", "galaxy");
    List<String> expected = Arrays.asList("moon", "Moon");
    List<String> filtered = ListExamples.filter(input, new IsMoon());
    assertEquals(expected, filtered);
  }

  //Testing merge
  @Test(timeout = 500)
  public void testMergeRightEnd() {
    List<String> left = Arrays.asList("a", "b", "c");
    List<String> right = Arrays.asList("a", "d");
    List<String> merged = ListExamples.merge(left, right);
    List<String> expected = Arrays.asList("a", "a", "b", "c", "d");
    assertEquals(expected, merged);
  }

  @Test(timeout = 500)
  public void testMergeLeftEnd() {
    List<String> right = Arrays.asList("b", "c", "d");
    List<String> left = Arrays.asList("a", "d");
    List<String> merged = ListExamples.merge(left, right);
    List<String> expected = Arrays.asList("a", "b", "c", "d", "d");
    assertEquals(expected, merged);
  }

  @Test(timeout = 500)
  public void testMergeEmptyLists() {
    List<String> list1 = Arrays.asList();
    List<String> list2 = Arrays.asList();
    List<String> merged = ListExamples.merge(list1, list2);
    List<String> expected = Arrays.asList();
    assertEquals(expected, merged);
  }

  @Test(timeout = 500)
  public void testMergeOneEmptyList() {
    List<String> list1 = Arrays.asList("a", "b", "c");
    List<String> list2 = Arrays.asList();
    List<String> merged = ListExamples.merge(list1, list2);
    List<String> expected = Arrays.asList("a", "b", "c");
    assertEquals(expected, merged);
  }

  @Test(timeout = 500)
  public void testMergeSameLists() {
    List<String> list1 = Arrays.asList("a", "b", "c");
    List<String> list2 = Arrays.asList("a", "b", "c");
    List<String> merged = ListExamples.merge(list1, list2);
    List<String> expected = Arrays.asList("a", "a", "b", "b", "c", "c");
    assertEquals(expected, merged);
  }

  @Test(timeout = 500)
  public void testMergeDifferentLists() {
    List<String> list1 = Arrays.asList("a", "c", "e");
    List<String> list2 = Arrays.asList("b", "d", "f");
    List<String> merged = ListExamples.merge(list1, list2);
    List<String> expected = Arrays.asList("a", "b", "c", "d", "e", "f");
    assertEquals(expected, merged);
  }

  @Test(timeout = 500)
  public void testMergeDuplicates() {
    List<String> list1 = Arrays.asList("a", "b", "c");
    List<String> list2 = Arrays.asList("b", "d", "e");
    List<String> merged = ListExamples.merge(list1, list2);
    List<String> expected = Arrays.asList("a", "b", "b", "c", "d", "e");
    assertEquals(expected, merged);
  }

  @Test(timeout = 500)
  public void testMergeWithDuplicatesAtEnd() {
    List<String> list1 = Arrays.asList("a", "b", "c");
    List<String> list2 = Arrays.asList("d", "e", "b");
    List<String> merged = ListExamples.merge(list1, list2);
    List<String> expected = Arrays.asList("a", "b", "c", "d", "e", "b");
    assertEquals(expected, merged);
  }

  @Test(timeout = 500)
  public void testMergeWithDuplicatesAtStart() {
    List<String> list1 = Arrays.asList("a", "b", "c");
    List<String> list2 = Arrays.asList("b", "d", "e");
    List<String> merged = ListExamples.merge(list2, list1);
    List<String> expected = Arrays.asList("a", "b", "b", "c", "d", "e");
    assertEquals(expected, merged);
  }
}
