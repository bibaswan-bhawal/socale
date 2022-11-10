import 'package:socale/models/ModelProvider.dart';
import 'package:socale/models/RoomListItem.dart';

class MatchRoom {
  final RoomListItem? room;
  final User? user;

  MatchRoom({this.room, this.user});

  @override
  String toString() {
    return "${room?.getRoom.id}: ${user?.id}";
  }
}
