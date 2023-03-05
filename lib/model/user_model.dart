class UserModel {
  String? uid;
  String? username;
  String? email;
  String? password;
  int total;
  UserModel(
      {this.total = 0, this.uid, this.username, this.email, this.password});

  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      username: map['username'],
      password: map['password'],
      total: map['total'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'password': password,
      'total': total
    };
  }
}
