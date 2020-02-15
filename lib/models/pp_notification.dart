class PPNotification {
  String title;
  String body;
  String type;
  String resourceId;
  PPNotification({title, body, id, resourceId, type}) {
    this.title = title ?? 'title';
    this.body = body ?? 'body';
    this.type = type ?? 'type';
    this.resourceId = resourceId ?? null;
  }

  factory PPNotification.fromMap(Map<String, dynamic> map) {
    return PPNotification(
        title: map['notification']['title'] ?? '',
        body: map['notification']['body'] ?? '',
        resourceId: map['data']['id'] != null ? map['data']['id'] : null);
  }

  @override
  String toString() {
    return "title: $title body: $body type: $type, resourceId: $resourceId";
  }
}
