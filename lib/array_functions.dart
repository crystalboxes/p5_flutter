class ArrayFunctions {
  factory ArrayFunctions._() => null;

  List<T> append<T>(List<T> array, T value) {
    array.add(value);
    return array;
  }

  /// Copies an array (or part of an array) to another array.
  /// The src array is copied to the dst array,
  /// beginning at the position specified by srcPosition and into the position
  /// specified by dstPosition.
  /// The number of elements to copy is determined by length.
  /// Note that copying values overwrites existing values in the destination array.
  /// To append values instead of overwriting them, use concat().
  ///
  /// Syntax:
  ///
  /// arrayCopy(src, srcPosition, dst, dstPosition, length);
  /// arrayCopy(src, dst, length);
  /// arrayCopy(src, dst);

  arrayCopy<T>(List<T> src, dynamic dstVar, [dynamic c, int d, int e]) {
    List<T> dst;
    var srcPosition = 0;
    var dstPosition = 0;
    var length = src.length;

    if (dstVar is int) {
      srcPosition = dstVar;
    } else if (dstVar is List<T>) {
      dst = dstVar;
      if (c != null && c is int) {
        length = c;
      }
    }

    if (c != null && c is List<T>) {
      dst = c;
      dstPosition = d;
      length = e;
    }

    for (int x = 0; x < length; x++) {
      if (x + srcPosition >= src.length) {
        return;
      }

      if (x + dstPosition >= dst.length) {
        return;
      }
      dst[x + dstPosition] = src[x + dstPosition];
    }
  }

  List<T> concat<T>(List<T> a, List<T> b) {
    List<T> c = List<T>(a.length + b.length);
    for (int x = 0; x < a.length + b.length; x++) {
      c[x] = x >= a.length ? b[x - a.length] : a[x];
    }
    return c;
  }

  List<T> expand<T>(List<T> data, [int newSize]) {
    if (newSize == null) {
      newSize = data.length * 2;
    }
    for (int x = 0; x < newSize; x++) {
      if (x == data.length) {
        data.add(data[0]);
      }
    }
    return data;
  }

  // TODO check if it reverses in place
  List<T> reverse<T>(List<T> list) {
    return list.reversed.toList();
  }

  List<T> shorten<T>(List<T> list) {
    List<T> out = List<T>(list.length - 1);
    for (int x = 0; x < list.length - 1; x++) {
      out[x] = list[x];
    }
    return out;
  }

  List<T> sort<T>(List<T> list) {
    list.sort();
    return list;
  }

  List<T> splice<T>(List<T> list, T value, int index) {
    list.insert(index, value);
  }

  List<T> subset<T>(List<T> list, int start, [int count]) {
    if (count == null) {
      list.sublist(start);
    } else {
      list.sublist(start, start + count);
    }
    return list;
  }
}
