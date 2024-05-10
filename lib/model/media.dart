class Media {
  String? originalUrl;
  String? fileName;
  int? size;
  String? humanReadableSize;
  String? mimeType;
  String? name;

  Media({
    this.originalUrl,
    this.fileName,
    this.size,
    this.humanReadableSize,
    this.mimeType,
    this.name,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      originalUrl: json['original_url'],
      fileName: json['file_name'],
      size: json['size'],
      humanReadableSize: json['human_readable_size'],
      mimeType: json['mime_type'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "original_url": originalUrl,
      "file_name": fileName,
      "size": size,
      "human_readable_size": humanReadableSize,
      "mime_type": mimeType,
      "name": name,
    };
  }
}
