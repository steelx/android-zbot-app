
class User {
  final String id;
  final String username;
  final String email;
  final String full_name;
  final String bio;
  final String image;
  final String created_at;
  final String updated_at;
  final List<String> location;


  User({
    this.id,
    this.username,
    this.email,
    this.full_name,
    this.bio,
    this.image,
    this.created_at,
    this.updated_at,
    this.location,
  });

  User.fromJson(Map<String, dynamic> data)
  :
    this.id = data["id"],
    this.username = data["username"],
    this.email = data["email"],
    this.full_name = data["full_name"],
    this.bio = data["bio"],
    this.image = data["image"],
    this.created_at = data["created_at"],
    this.updated_at = data["updated_at"],
    this.location = data["location"];

  Map<String, dynamic> toJson() => {
    "id": this.id,
    "username": this.username,
    "email": this.email,
    "full_name": this.full_name,
    "bio": this.bio,
    "image": this.image,
    "created_at": this.created_at,
    "updated_at": this.updated_at,
    "location": this.location,
  };
}