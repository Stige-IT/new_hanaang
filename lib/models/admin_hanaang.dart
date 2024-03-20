class AdminHanaang {
  String? id;
  String? image;
  String? name;
  String? email;
  String? phoneNummber;
  String? suspend;

  AdminHanaang(
      {this.id,
        this.image,
        this.name,
        this.email,
        this.phoneNummber,
        this.suspend});

  AdminHanaang.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    email = json['email'];
    phoneNummber = json['phone_nummber'];
    suspend = json['suspend'];
  }

}
