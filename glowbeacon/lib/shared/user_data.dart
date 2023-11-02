class UserData {
  // Private constructor
  UserData._privateConstructor();

  // Static instance variable
  static final UserData _instance = UserData._privateConstructor();

  // Factory method to return the same instance
  factory UserData() {
    return _instance;
  }

  // User data fields
  String? email;
  String? fullName;
  String? username;
  String? uid;
  List<String>? followers;
  List<String>? following;
  bool initialized = false;
  // ... add other fields as needed

  // Method to set user data
  void setUserData({
    required String email,
    required String fullName,
    required String? username,
    required String uid,
    List<String>? followers,
    List<String>? following,
    // ... other fields
  }) {
    this.email = email;
    this.fullName = fullName;
    this.username = username;
    this.uid = uid;
    this.followers = followers;
    this.following = following;
    initialized = true;
    // ... set other fields
  }

  // You can also add methods to get specific data, clear data, etc.
}
