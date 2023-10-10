
class Employee {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String avatar;

  Employee({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.avatar,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      avatar: json['avatar'],
    );
  }
}
