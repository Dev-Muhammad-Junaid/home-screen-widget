import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class HomeDataRecord extends FirestoreRecord {
  HomeDataRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  bool hasTitle() => _title != null;

  // "count" field.
  int? _count;
  int get count => _count ?? 0;
  bool hasCount() => _count != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  void _initializeFields() {
    _title = snapshotData['title'] as String?;
    _count = castToType<int>(snapshotData['count']);
    _createdAt = snapshotData['createdAt'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('homeData');

  static Stream<HomeDataRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => HomeDataRecord.fromSnapshot(s));

  static Future<HomeDataRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => HomeDataRecord.fromSnapshot(s));

  static HomeDataRecord fromSnapshot(DocumentSnapshot snapshot) =>
      HomeDataRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static HomeDataRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      HomeDataRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'HomeDataRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is HomeDataRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createHomeDataRecordData({
  String? title,
  int? count,
  DateTime? createdAt,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'title': title,
      'count': count,
      'createdAt': createdAt,
    }.withoutNulls,
  );

  return firestoreData;
}

class HomeDataRecordDocumentEquality implements Equality<HomeDataRecord> {
  const HomeDataRecordDocumentEquality();

  @override
  bool equals(HomeDataRecord? e1, HomeDataRecord? e2) {
    return e1?.title == e2?.title &&
        e1?.count == e2?.count &&
        e1?.createdAt == e2?.createdAt;
  }

  @override
  int hash(HomeDataRecord? e) =>
      const ListEquality().hash([e?.title, e?.count, e?.createdAt]);

  @override
  bool isValidKey(Object? o) => o is HomeDataRecord;
}
