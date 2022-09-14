import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:socale/amplifyconfiguration.dart';
import 'package:socale/models/ModelProvider.dart';

Future<void> configureDataStore() async {
  final dataStorePlugin = AmplifyDataStore(
    modelProvider: ModelProvider.instance,
  );
  final apiPlugin = AmplifyAPI(modelProvider: ModelProvider.instance);
  await Amplify.addPlugins([apiPlugin, dataStorePlugin]);
  await Amplify.configure(amplifyconfig);
}

main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await configureDataStore();
    await Amplify.DataStore.clear();
  });

  testWidgets(
    'should emit events with nested data',
    (WidgetTester tester) async {
      List<String> result = [];

      // Nested data (message.author.firstName)
      Amplify.DataStore.observeQuery(Message.classType).listen((QuerySnapshot<Message> snapshot) {
        if (snapshot.items.isEmpty) {
          print("snapshot started");
        }

        for (Message message in snapshot.items) {
          print(message.author.firstName);
        }
      });

      final user1 = User(
        firstName: 'user 1',
        lastName: 'Bob',
        academicInterests: const [],
        careerGoals: const [],
        college: '',
        dateOfBirth: TemporalDate.now(),
        email: '',
        graduationMonth: TemporalDate.now(),
        idealFriendDescription: '',
        leisureInterests: const [],
        major: const [],
        matches: const [],
        minor: const [],
        schoolEmail: '',
        selfDescription: const [],
        situationalDecisions: const [],
        skills: const [],
        anonymousUsername: 'bob',
        introMatchingCompleted: false,
        avatar: 'Artist Raccoon.png',
      );

      final user2 = User(
        firstName: 'user 2',
        lastName: 'Bob',
        academicInterests: const [],
        careerGoals: const [],
        college: '',
        dateOfBirth: TemporalDate.now(),
        email: '',
        graduationMonth: TemporalDate.now(),
        idealFriendDescription: '',
        leisureInterests: const [],
        major: const [],
        matches: const [],
        minor: const [],
        schoolEmail: '',
        selfDescription: const [],
        situationalDecisions: const [],
        skills: const [],
        anonymousUsername: 'bib',
        introMatchingCompleted: false,
        avatar: 'Artist Raccoon.png',
      );

      final room1 = Room();

      final userRoom1 = UserRoom(
        user: user1,
        room: room1,
      );
      final userRoom2 = UserRoom(
        user: user2,
        room: room1,
      );

      final message1 = Message(
        author: user1,
        room: room1,
        createdAt: TemporalDateTime.now(),
        encryptedText: 'text 1',
      );

      // create users
      await Amplify.DataStore.save(user1);
      await Amplify.DataStore.save(user2);

      //create room
      await Amplify.DataStore.save(room1);

      // create userRooms
      await Amplify.DataStore.save(userRoom1);
      await Amplify.DataStore.save(userRoom2);

      // Create message

      await Future.delayed(Duration(seconds: 4), () async {
        await Amplify.DataStore.save(message1);
      });
    },
  );
}
