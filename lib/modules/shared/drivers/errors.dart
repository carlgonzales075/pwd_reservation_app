class DirectusErrors {
  final String? message;
  final String? code;
  final String? collection;
  final String? field;

  DirectusErrors(
    this.message,
    this.code,
    this.collection,
    this.field
  );

  factory DirectusErrors.fromJson(Map<String, dynamic>? json) {
    String? message = json?['message'];
    String? code = json?['extensions']['code'];
    String? collection = json?['extensions']['collection'];
    String? field = json?['extensions']['field'];
    return DirectusErrors(message, code, collection, field);
  }
}