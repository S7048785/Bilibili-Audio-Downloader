class Video {
  String bvid;
  String title;
  String author;
  String duration;

  Video({
    required this.bvid,
    required this.title,
    required this.author,
    required this.duration,
  });

  factory Video.fromJson(Map<String, dynamic> json) => Video(
    bvid: json['bvid'],
    title: json['title'],
    author: json['author'],
    duration: json['time'],
  );

  Map<String, dynamic> toJson() => {
    'bvid': bvid,
    'title': title,
    'author': author,
    'time': duration,
  };
}
