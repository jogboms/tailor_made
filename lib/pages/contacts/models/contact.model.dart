class ContactModel {
  String fullname;
  String phone;
  String location;
  String imageUrl;
  int totalJobs;
  int hasPending;

  ContactModel({
    this.fullname,
    this.phone,
    this.location,
    this.imageUrl,
    this.totalJobs = 0,
    this.hasPending = 0,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    assert(json != null);
    return new ContactModel(
      fullname: json['fullname'],
      phone: json['phone'],
      location: json['location'],
      imageUrl: json['imageUrl'],
      totalJobs: int.tryParse(json['totalJobs'].toString()),
      hasPending: int.tryParse(json['hasPending'].toString()),
    );
  }

  toMap() {
    return {
      "fullname": fullname.toString(),
      "phone": phone.toString(),
      "location": location.toString(),
      "imageUrl": imageUrl.toString(),
      "totalJobs": totalJobs.toString(),
      "hasPending": hasPending.toString(),
    };
  }
}
