import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'network_list.freezed.dart';

part 'network_list.g.dart';

@Freezed(genericArgumentFactories: true)
class NetworkList<T> with _$NetworkList<T> {
  const NetworkList._();

  const factory NetworkList({
    required List<T> list,
  }) = _NetworkList;

  const factory NetworkList.loading() = _NetworkListLoading;

  factory NetworkList.fromJson(Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$NetworkListFromJson(json, fromJsonT);
}
