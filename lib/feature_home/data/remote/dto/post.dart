class PostDto{
  final String ? title;
  final String ? description;

  const PostDto({
    this.title,
    this.description
  });

  factory PostDto.fromJson(Map<String, dynamic> map){
    return PostDto(
      title: map["title"] ?? "",
      description: map["description"] ?? ""
    );
  }
}