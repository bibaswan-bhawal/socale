import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:socale/models/RoomListItem.dart';
import 'package:socale/services/fetch_service.dart';

import '../../models/ModelProvider.dart';

class RoomsStateNotifier extends StateNotifier<AsyncValue<List<RoomListItem>>> {
  StreamSubscription<QuerySnapshot<UserRoom>>? _streamUserRooms;
  StreamSubscription<QuerySnapshot<Room>>? _streamRooms;

  RoomsStateNotifier() : super(AsyncLoading()) {
    requestRooms();
  }

  @override
  void dispose() {
    super.dispose();
    _streamRooms?.cancel();
    _streamUserRooms?.cancel();
  }

  Future<void> requestRooms() async {
    if (_streamUserRooms != null) {
      _streamUserRooms!.cancel();
    }

    final currentUserId = (await Amplify.Auth.getCurrentUser()).userId;

    _streamUserRooms = Amplify.DataStore.observeQuery(
      UserRoom.classType,
      where: UserRoom.USER.eq(currentUserId),
    ).listen(
      (QuerySnapshot<UserRoom> snapshot) async {
        if (snapshot.isSynced) {
          List<String> newRoomId = [];

          for (UserRoom userRoom in snapshot.items) {
            newRoomId.addIf(
                !newRoomId.contains(userRoom.room.id), userRoom.room.id);
          }

          if (_streamRooms != null) {
            _streamRooms!.cancel();
          }

          if (newRoomId.isNotEmpty) {
            QueryPredicate roomPredicate = Room.ID.eq(newRoomId[0]);
            QueryPredicateGroup? multiRoomPredicate;

            if (newRoomId.length > 1) {
              multiRoomPredicate =
                  Room.ID.eq(newRoomId[0]).or(Room.ID.eq(newRoomId[1]));

              for (int i = 2; i < newRoomId.length; i++) {
                multiRoomPredicate =
                    multiRoomPredicate!.or(Room.ID.eq(newRoomId[i]));
              }
            }

            var queryPredicate = multiRoomPredicate ?? roomPredicate;

            _streamRooms = Amplify.DataStore.observeQuery(
              Room.classType,
              where: queryPredicate,
            ).listen((QuerySnapshot<Room> snapshot) async {
              if (snapshot.isSynced) {
                List<RoomListItem> roomsListItems = [];

                for (Room room in snapshot.items) {
                  List<User> usersForRoom =
                      await fetchService.fetchAllUsersForRoom(room);
                  User? currentUser =
                      await fetchService.fetchUserById(currentUserId);
                  if (currentUser == null) continue;
                  RoomListItem itemToAdd =
                      RoomListItem(room, usersForRoom, currentUser);
                  roomsListItems.addIf(
                      !roomsListItems.contains(itemToAdd), itemToAdd);
                }

                roomsListItems.sort((room1, room2) => room1.compareTo(room2));
                if (mounted) {
                  state = AsyncData(roomsListItems.reversed.toList());
                }
              }
            });
          }
        }
      },
    );
  }
}
