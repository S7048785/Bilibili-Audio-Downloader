import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// 品牌颜色
class BrandColor extends ThemeExtension<BrandColor> {
  final Color color;
  final Color inputBackGroundColor;
  final Color containerColor;
  final Color bottomNavigationBarColor;
  final Color iconColor;
  final Color shadowColor;
  final Color textColor;


  const BrandColor({
    required this.color,
    required this.inputBackGroundColor,
    required this.containerColor,
    required this.bottomNavigationBarColor,
    required this.iconColor,
    required this.shadowColor,
    required this.textColor,
  });

  @override
  BrandColor copyWith({
    Color? color,
    Color? inputBackGroundColor,
    Color? containerColor,
    Color? bottomNavigationBarColor,
    Color? iconColor,
    Color? shadowColor,
    Color? textColor,
  }) => BrandColor(
    color: color ?? this.color,
    inputBackGroundColor: inputBackGroundColor ?? this.inputBackGroundColor,
    containerColor: containerColor ?? this.containerColor,
    bottomNavigationBarColor: bottomNavigationBarColor ?? this.bottomNavigationBarColor,
    iconColor: iconColor ?? this.iconColor,
    textColor: textColor ?? this.textColor,
    shadowColor: shadowColor ?? this.shadowColor,
  );

  @override
  BrandColor lerp(BrandColor? other, double t) {
    if (other is! BrandColor) {
      return this;
    }

    return BrandColor(
      color: Color.lerp(color, other.color, t)!,
      inputBackGroundColor: Color.lerp(
        inputBackGroundColor,
        other.inputBackGroundColor,
        t,
      )!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
      iconColor: Color.lerp(iconColor, other.iconColor, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
      bottomNavigationBarColor: Color.lerp(
        bottomNavigationBarColor,
        other.bottomNavigationBarColor,
        t,
      )!,
      containerColor: Color.lerp(containerColor, other.containerColor, t)!,
    );
  }

  /// 获取品牌颜色
  static BrandColor getColor(BuildContext context) {
    return FThemeBuildContext(context).theme.extension<BrandColor>();
  }
}
