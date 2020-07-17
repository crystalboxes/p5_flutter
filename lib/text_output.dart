class TextOutput {
  factory TextOutput._() => null;

  printArray(List<dynamic> what) {
    for (int x = 0; x < what.length; x++) {
      print('[$x] ${what[x].toString()}');
    }
  }

  println([dynamic what]) {
    if (what != null) {
      if (what is String) {
        print('$what\n');
        return;
      } else if (what is List<dynamic>) {
        print(what.reduce((value, element) => '$value, ${element.toString()}'));
        print('\n');
        return;
      }
    }
    print('\n');
  }
}
