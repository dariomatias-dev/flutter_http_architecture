class HttpAdvancedItem {
  final String id;
  final String key;
  final String value;

  HttpAdvancedItem({this.key = '', this.value = ''})
    : id = DateTime.now().toString();

  HttpAdvancedItem copyWith({String? key, String? value}) {
    return HttpAdvancedItem(key: key ?? this.key, value: value ?? this.value);
  }
}
