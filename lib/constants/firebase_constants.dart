import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final fbStore = FirebaseFirestore.instance;
final firebaseAuth = FirebaseAuth.instance;

final usersCollection = fbStore.collection('users');
