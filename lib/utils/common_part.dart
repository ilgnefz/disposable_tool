// 方案一
String commonPart(List<String> strings) {
  if (strings.isEmpty) return '';
  final sortedStrings = strings..sort((a, b) => a.length.compareTo(b.length));
  final shortestString = sortedStrings.first;
  for (int i = shortestString.length; i >= 0; i--) {
    final prefix = shortestString.substring(0, i);
    if (sortedStrings.every((string) => string.startsWith(prefix))) {
      return prefix;
    }
  }
  return '';
}

// 方案二
String commonSubstring(String str1, String str2) {
  for (int i = 0; i < str1.length; i++) {
    for (int j = str1.length; j > i; j--) {
      String sub = str1.substring(i, j);
      if (str2.contains(sub)) {
        return sub;
      }
    }
  }
  return "";
}

String commonSubstringMultiple(List<String> strings) {
  String common = strings[0];
  for (int i = 1; i < strings.length; i++) {
    common = commonSubstring(common, strings[i]);
    if (common.isEmpty) {
      return "";
    }
  }
  return common;
}

// 方案三
// String commonSubstringMultiple(List<String> strings) {
//   String common = strings[0];
//   for (int i = 1; i < strings.length; i++) {
//     String str1 = common;
//     String str2 = strings[i];
//     common = "";
//     for (int j = 0; j < str1.length; j++) {
//       for (int k = str1.length; k > j; k--) {
//         String sub = str1.substring(j, k);
//         if (str2.indexOf(sub) != -1 && sub.length > common.length) {
//           common = sub;
//         }
//       }
//     }
//     if (common.isEmpty) {
//       return "";
//     }
//   }
//   return common;
// }
