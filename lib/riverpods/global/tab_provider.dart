import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils/enums/tab_item.dart';

final tabProvider = StateProvider<TabItem>(
  // We return the default sort type, here name.
  (ref) => TabItem.home,
);
