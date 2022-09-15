import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';
import 'index.dart';



@immutable
class MotProperty {

  const MotProperty({
    required this.motMetaKey,
    required this.motMetaValues,
  });

  final String motMetaKey;
  final List<String> motMetaValues;

  factory MotProperty.fromJson(Map<String,dynamic> json) => MotProperty(
    motMetaKey: json['motMetaKey'].toString(),
    motMetaValues: (json['motMetaValues'] as List? ?? []).map((e) => e as String).toList()
  );
  
  Map<String, dynamic> toJson() => {
    'motMetaKey': motMetaKey,
    'motMetaValues': motMetaValues.map((e) => e.toString()).toList()
  };

  MotProperty clone() => MotProperty(
    motMetaKey: motMetaKey,
    motMetaValues: motMetaValues.toList()
  );


  MotProperty copyWith({
    String? motMetaKey,
    List<String>? motMetaValues
  }) => MotProperty(
    motMetaKey: motMetaKey ?? this.motMetaKey,
    motMetaValues: motMetaValues ?? this.motMetaValues,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is MotProperty && motMetaKey == other.motMetaKey && motMetaValues == other.motMetaValues;

  @override
  int get hashCode => motMetaKey.hashCode ^ motMetaValues.hashCode;
}
