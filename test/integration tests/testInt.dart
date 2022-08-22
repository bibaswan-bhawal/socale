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
      // Nested data (message.author.firstName)
      final nameStream = Amplify.DataStore.observeQuery(Message.classType).map(
        (event) => event.items.map((item) => item.author.firstName),
      );

      expectLater(
        nameStream,
        emitsInOrder([
          orderedEquals([]),
          orderedEquals(['user 1']),
        ]),
      );

      final user1 = User(
        firstName: 'user 1',
        academicInclination: 0,
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
        privateKey: const [],
        publicKey: '',
        schoolEmail: '',
        selfDescription: const [],
        situationalDecisions: const [],
        skills: const [],
      );

      final user2 = User(
        firstName: 'user 2',
        academicInclination: 0,
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
        privateKey: const [],
        publicKey: '',
        schoolEmail: '',
        selfDescription: const [],
        situationalDecisions: const [],
        skills: const [],
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
      await Amplify.DataStore.save(message1);
    },
  );
}
