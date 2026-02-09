class MyNotification {
  String title;
  String body;
  String? imageUrl;

  MyNotification({
    required this.title,
    required this.body,
    this.imageUrl,
  });

  factory MyNotification.fromJson(Map<String, dynamic> json) {
    return MyNotification(
      title: json['title'],
      body: json['body'],
      imageUrl: json['imageUrl'] ?? "",
    );
  }
}
