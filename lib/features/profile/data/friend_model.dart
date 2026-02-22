/// A friend in "My Friends" list.
class FriendModel {
  const FriendModel({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.travelCount = 0,
  });

  final String id;
  final String name;
  final String? avatarUrl;
  final int travelCount;
}
