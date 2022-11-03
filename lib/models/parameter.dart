import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';
import 'index.dart';

@immutable
class Parameter {
  const Parameter({
    required this.id,
    required this.parmName,
    required this.type,
    required this.permission,
    required this.enumValue,
    required this.sliderMin,
    required this.sliderMax,
    required this.toolTip,
    required this.motProperties,
    required this.motId,
  });

  final int id;
  final String parmName;
  ParameterTypeEnum get parameterTypeEnum =>
      _parameterTypeEnumValues.map[type]!;
  final String type;
  ParameterPermissionEnum get parameterPermissionEnum =>
      _parameterPermissionEnumValues.map[permission]!;
  final String permission;
  final List<String> enumValue;
  final double sliderMin;
  final double sliderMax;
  final String toolTip;
  final Map motProperties;
  final int motId;

  factory Parameter.fromJson(Map<String, dynamic> json) => Parameter(
        id: json['id'] as int,
        parmName: json['parm_name'].toString(),
        type: json['@type'].toString(),
        permission: json['@permission'].toString(),
        enumValue: (json['enum_value'] as List? ?? [])
            .map((e) => e as String)
            .toList(),
        sliderMin: json['slider_min'] as double,
        sliderMax: json['slider_max'] as double,
        toolTip: json['toolTip'].toString(),
        motProperties: json['motProperties'] as Map? ?? {},
        motId: json['motId'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'parm_name': parmName,
        '@type': type,
        '@permission': permission,
        'enum_value': enumValue.map((e) => e.toString()).toList(),
        'slider_min': sliderMin,
        'slider_max': sliderMax,
        'toolTip': toolTip,
        'motProperties': motProperties,
        'motId': motId,
      };

  Parameter clone() => Parameter(
        id: id,
        parmName: parmName,
        type: type,
        permission: permission,
        enumValue: enumValue.toList(),
        sliderMin: sliderMin,
        sliderMax: sliderMax,
        toolTip: toolTip,
        motProperties: motProperties,
        motId: motId,
      );

  Parameter copyWith(
          {int? id,
          String? parmName,
          String? type,
          String? permission,
          List<String>? enumValue,
          double? sliderMin,
          double? sliderMax,
          String? toolTip,
          Map? motProperties,
          int? motId}) =>
      Parameter(
        id: id ?? this.id,
        parmName: parmName ?? this.parmName,
        type: type ?? this.type,
        permission: permission ?? this.permission,
        enumValue: enumValue ?? this.enumValue,
        sliderMin: sliderMin ?? this.sliderMin,
        sliderMax: sliderMax ?? this.sliderMax,
        toolTip: toolTip ?? this.toolTip,
        motProperties: motProperties ?? this.motProperties,
        motId: motId ?? this.motId,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Parameter &&
          id == other.id &&
          parmName == other.parmName &&
          type == other.type &&
          permission == other.permission &&
          enumValue == other.enumValue &&
          sliderMin == other.sliderMin &&
          sliderMax == other.sliderMax &&
          toolTip == other.toolTip &&
          motProperties == other.motProperties &&
          motId == other.motId;

  @override
  int get hashCode =>
      id.hashCode ^
      parmName.hashCode ^
      type.hashCode ^
      permission.hashCode ^
      enumValue.hashCode ^
      sliderMin.hashCode ^
      sliderMax.hashCode ^
      toolTip.hashCode ^
      motProperties.hashCode ^
      motId.hashCode;
}

enum ParameterTypeEnum { Input, Enum, Slider, Switcher }

extension ParameterTypeEnumEx on ParameterTypeEnum {
  String? get value => _parameterTypeEnumValues.reverse[this];
}

final _parameterTypeEnumValues = _ParameterTypeEnumConverter({
  'input': ParameterTypeEnum.Input,
  'enum': ParameterTypeEnum.Enum,
  'slider': ParameterTypeEnum.Slider,
  'switcher': ParameterTypeEnum.Switcher,
});

class _ParameterTypeEnumConverter<String, O> {
  final Map<String, O> map;
  Map<O, String>? reverseMap;

  _ParameterTypeEnumConverter(this.map);

  Map<O, String> get reverse =>
      reverseMap ??= map.map((k, v) => MapEntry(v, k));
}

enum ParameterPermissionEnum { Read, Write }

extension ParameterPermissionEnumEx on ParameterPermissionEnum {
  String? get value => _parameterPermissionEnumValues.reverse[this];
}

final _parameterPermissionEnumValues = _ParameterPermissionEnumConverter({
  'read': ParameterPermissionEnum.Read,
  'write': ParameterPermissionEnum.Write,
});

class _ParameterPermissionEnumConverter<String, O> {
  final Map<String, O> map;
  Map<O, String>? reverseMap;

  _ParameterPermissionEnumConverter(this.map);

  Map<O, String> get reverse =>
      reverseMap ??= map.map((k, v) => MapEntry(v, k));
}
