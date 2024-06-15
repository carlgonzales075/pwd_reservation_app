class User {
  final String userId;
  final String firstName;
  final String lastName;
  final String? avatar;
  final String? email;
  final String? role;

  const User({
    required this.userId,
    required this.firstName,
    required this.lastName,
    this.avatar,
    this.email,
    this.role
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;

    if (data != null) {
      final userId = data['id'].toString();
      final firstName = data['first_name'] as String?;
      final lastName = data['last_name'] as String?;
      final avatar = data['avatar'] as String?;
      final email = data['email'] as String?;
      final role = data['role']['name'] as String?;
      if (firstName != null && lastName != null) {
        return User(
          userId: userId,
          firstName: firstName,
          lastName: lastName,
          avatar: avatar,
          email: email,
          role: role
        );
      }
    }
  
    throw const FormatException('Failed to load credentials.');
  }
}

class Credentials {
  final String accessToken;
  final int expires;
  final String refreshToken;

  const Credentials({
    required this.accessToken,
    required this.expires,
    required this.refreshToken
  });

  factory Credentials.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;

    if (data != null) {
      final accessToken = data['access_token'] as String?;
      final expires = data['expires'] as int?;
      final refreshToken = data['refresh_token'] as String?;

      if (accessToken != null && expires != null && refreshToken != null) {
        return Credentials(
          accessToken: accessToken,
          expires: expires,
          refreshToken: refreshToken,
        );
      }
    }
  
  throw const FormatException('Failed to load credentials.');
  }
}