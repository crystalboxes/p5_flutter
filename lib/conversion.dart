import 'dart:math';

const INTEGER_SIZE = 32;
const _digits = [
  '0',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  'a',
  'b',
  'c',
  'd',
  'e',
  'f',
  'g',
  'h',
  'i',
  'j',
  'k',
  'l',
  'm',
  'n',
  'o',
  'p',
  'q',
  'r',
  's',
  't',
  'u',
  'v',
  'w',
  'x',
  'y',
  'z'
];

class Conversion {
  static int _formatUnsignedInt(
      int val, int shift, List<int> buf, int offset, int len) {
    int charPos = len;
    int radix = 1 << shift;
    int mask = radix - 1;
    do {
      buf[offset + --charPos] = _digits[val & mask].codeUnitAt(0);
      val = (val & 0xffffffff) >> shift;
    } while (val != 0 && charPos > 0);

    return charPos;
  }

  static int _numberOfLeadingZeros(int i) {
    // HD, Figure 5-6
    if (i == 0) return 32;
    int n = 1;
    if ((i & 0xffffffff) >> 16 == 0) {
      n += 16;
      i <<= 16;
    }
    if ((i & 0xffffffff) >> 24 == 0) {
      n += 8;
      i <<= 8;
    }
    if ((i & 0xffffffff) >> 28 == 0) {
      n += 4;
      i <<= 4;
    }
    if ((i & 0xffffffff) >> 30 == 0) {
      n += 2;
      i <<= 2;
    }
    n -= (i & 0xffffffff) >> 31;
    return n;
  }

  static String _toUnsignedString0(int val, int shift) {
    // assert shift > 0 && shift <=5 : "Illegal shift value";
    int mag = INTEGER_SIZE - _numberOfLeadingZeros(val);
    int chars = max((mag + (shift - 1)) ~/ shift, 1);
    List<int> buf = List<int>(chars);

    _formatUnsignedInt(val, shift, buf, 0, chars);

    // Use special constructor which takes over "buf".
    var s = '';
    buf.forEach((element) {
      s += String.fromCharCode(element);
    });
    return s;
  }

  String binary(int value, [int digits]) {
    if (digits == null) {
      digits = 32;
    }
    String stuff = _toUnsignedString0(value, 1);
    if (digits > 32) {
      digits = 32;
    }

    int length = stuff.length;
    if (length > digits) {
      return stuff.substring(length - digits);
    } else if (length < digits) {
      int offset = 32 - (digits - length);
      return "00000000000000000000000000000000".substring(offset) + stuff;
    }
    return stuff;
  }

  bool boolean(dynamic what) {
    if (what is String && what == 'true') {
      return true;
    }
    if (what is int && what != 0) {
      return true;
    }
    return false;
  }

  int byte(dynamic what) {
    if (what is bool) {
      return what ? 1 : 0;
    } else if (what is String) {
      what.codeUnitAt(0);
    } else if (what is num) {
      return what.toInt() & 0xFF;
    }
    return 0;
  }

  String char(num what) {
    return String.fromCharCode(what.toInt() & 0xFF);
  }

  double float(dynamic what) {
    if (what is String) {
      double.parse(what);
    } else if (what is int) {
      return what.toDouble();
    } else if (what is double) {
      return what;
    }
    return double.nan;
  }

  String hex(int value, [int digits]) {
    if (digits == null) {
      digits = 8;
    }
    String stuff = _toUnsignedString0(value, 4).toUpperCase();

    int length = stuff.length;
    if (length > digits) {
      return stuff.substring(length - digits);
    } else if (length < digits) {
      return "00000000".substring(8 - (digits - length)) + stuff;
    }
    return stuff;
  }

  String str(dynamic val) => val.toString();

  int unbinary(String value) => int.parse(value, radix: 2);
  int unhex(String value) => int.parse(value, radix: 16);
}
