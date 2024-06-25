import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';

@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    @Default('') String id,
    @Default('') String name,
    @Default('') String email,
  }) = _AppUser;

  factory AppUser.fromDoc(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return AppUser(
      id: snapshot.id,
      name: data['name'],
      email: data['email'],
    );
  }
}
