class UserProfile {
  final String name;
  final String email;
  final String? photoUrl;
  final int vibeCheckDay;
  final int vibeCheckSecondDay;
  final int vibeCheckFrequency;

  const UserProfile({
    required this.name,
    required this.email,
    this.photoUrl,
    this.vibeCheckDay = 28,
    this.vibeCheckSecondDay = 15,
    this.vibeCheckFrequency = 1,
  });
}
