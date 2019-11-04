import 'package:mockito/mockito.dart';
import 'package:movie_watchlists/blocs/watchlist_create_bloc.dart';
import 'package:movie_watchlists/data/repos/watchlist_repository.dart';
import 'package:movie_watchlists/shared/result.dart';
import 'package:test/test.dart';

import '../../test_utils.dart';

main() {

  /*
  test('should create a new watchlist', () async {
    final mockHandler = MockAuthHandler();
    final mockUser = MockFirebaseUser();
    final mockFirestore = MockFirestore();
    final mockCollection = MockCollectionReference();
    final mockDocument = MockDocumentReference();

    when(mockHandler.currentUser())
      .thenAnswer((_) => Future.value(Result.success(mockUser)));

    when(mockUser.uid).thenReturn("1234");

    when(mockFirestore.collection(any))
      .thenReturn(mockCollection);

    when(mockCollection.add(any))
      .thenAnswer((_) => Future.value(mockDocument));

    final repo = WatchlistRepository(
      handler: mockHandler,
      firestore: mockFirestore
    );

    final settings = WatchlistSettings(
      watchlistName: "name",
      notifications: true,
      modifications: true,
      adultContent: true
    );

    final result = await repo.create(settings);
    expect(result.hasError, isFalse);
    expect(result.result, isTrue);

    verify(mockHandler.currentUser()).called(1);
    verify(mockUser.uid).called(1);
    verify(mockFirestore.collection(any)).called(1);
    verify(mockCollection.add(any)).called(1);
    // TODO: could verify map was updated?
  });


  test('should find all watchlists', () async {
    const MethodChannel('plugins.flutter.io/cloud_firestore')
      .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'Query#getDocuments') {
        return {}; // set initial values here if desired
      }
      return null;
    });

    final mockHandler = MockAuthHandler();
    final mockUser = MockFirebaseUser();
    final mockFirestore = MockFirestore();
    final mockCollectionReference = MockCollectionReference();
    final mockQuery = MockQuery();
    final mockSnapshot = MockQuerySnapshot();

    when(mockHandler.currentUser())
      .thenAnswer((_) => Future.value(Result.success(mockUser)));

    when(mockUser.uid).thenReturn("1234");

    when(mockFirestore.collection(any))
      .thenReturn(mockCollectionReference);

    when(mockCollectionReference.where(any))
      .thenReturn(mockQuery);

    when(mockQuery.getDocuments())
      .thenAnswer((_) => Future.value(mockSnapshot));

    when(mockSnapshot.documents)
      .thenReturn([]);

    final repo = WatchlistRepository(
      handler: mockHandler,
      firestore: mockFirestore
    );

    final result = await repo.findAll();
    expect(result.hasError, isFalse);
    expect(result.result, isEmpty);
  });
  */
}