import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // تسجيل الدخول
  Future<AppUser?> signIn(String email, String password) async {
    UserCredential credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    if (credential.user != null) {
      return await getUserData(credential.user!.uid);
    }
    return null;
  }

  // جلب بيانات المستخدم الحالي
  Future<AppUser?> getUserData(String uid) async {
    DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      return AppUser.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  // إنشاء يوزر جديد بواسطة المدير
  Future<void> createNewUserByManager({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    // إنشاء الحساب في Firebase Auth
    UserCredential credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    // إضافة البيانات و Role في Firestore
    await _db.collection('users').doc(credential.user!.uid).set({
      'name': name,
      'email': email.trim(),
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // تسجيل الخروج
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

