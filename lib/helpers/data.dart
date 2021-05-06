class OneNotification {
  int id;
  String title, body, date;
  bool seen;
  OneNotification() {
    seen = false;
    title = '';
    body = '';
    date = DateTime.now().toString();
  }
}
