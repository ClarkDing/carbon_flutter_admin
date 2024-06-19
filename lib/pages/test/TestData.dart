
class Testdata {

  static Testdata? _instance;

  static Testdata get instance {
    if (_instance == null) {
      _instance = Testdata._internal();
    }
    return _instance!;
  }

  Testdata._internal();

}

void function () {
  Testdata.instance;
}