import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff060607),
      surfaceTint: Color(0xff5f5e5e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff1f1f1f),
      onPrimaryContainer: Color(0xff888686),
      secondary: Color(0xff5f5e5e),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffe5e2e1),
      onSecondaryContainer: Color(0xff656464),
      tertiary: Color(0xff2d6900),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff3a8500),
      onTertiaryContainer: Color(0xfff9ffed),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffcf8f8),
      onSurface: Color(0xff1c1b1b),
      onSurfaceVariant: Color(0xff444748),
      outline: Color(0xff747878),
      outlineVariant: Color(0xffc4c7c8),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff313030),
      inversePrimary: Color(0xffc8c6c5),
      primaryFixed: Color(0xffe5e2e1),
      onPrimaryFixed: Color(0xff1b1b1c),
      primaryFixedDim: Color(0xffc8c6c5),
      onPrimaryFixedVariant: Color(0xff474746),
      secondaryFixed: Color(0xffe5e2e1),
      onSecondaryFixed: Color(0xff1c1b1b),
      secondaryFixedDim: Color(0xffc9c6c5),
      onSecondaryFixedVariant: Color(0xff474646),
      tertiaryFixed: Color(0xffa3f86f),
      onTertiaryFixed: Color(0xff092100),
      tertiaryFixedDim: Color(0xff88db56),
      onTertiaryFixedVariant: Color(0xff215100),
      surfaceDim: Color(0xffddd9d9),
      surfaceBright: Color(0xfffcf8f8),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff7f3f2),
      surfaceContainer: Color(0xfff1edec),
      surfaceContainerHigh: Color(0xffebe7e7),
      surfaceContainerHighest: Color(0xffe5e2e1),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff060607),
      surfaceTint: Color(0xff5f5e5e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff1f1f1f),
      onPrimaryContainer: Color(0xffabaaa9),
      secondary: Color(0xff373636),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff6e6d6c),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff183f00),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff367c00),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffcf8f8),
      onSurface: Color(0xff111111),
      onSurfaceVariant: Color(0xff333738),
      outline: Color(0xff4f5354),
      outlineVariant: Color(0xff6a6e6e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff313030),
      inversePrimary: Color(0xffc8c6c5),
      primaryFixed: Color(0xff6e6d6c),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff555454),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff6e6d6c),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff565454),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff367c00),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff296100),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc9c6c5),
      surfaceBright: Color(0xfffcf8f8),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff7f3f2),
      surfaceContainer: Color(0xffebe7e7),
      surfaceContainerHigh: Color(0xffdfdcdb),
      surfaceContainerHighest: Color(0xffd4d1d0),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff060607),
      surfaceTint: Color(0xff5f5e5e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff1f1f1f),
      onPrimaryContainer: Color(0xffd6d4d3),
      secondary: Color(0xff2c2c2c),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff4a4949),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff123300),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff225400),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffcf8f8),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff292d2d),
      outlineVariant: Color(0xff464a4a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff313030),
      inversePrimary: Color(0xffc8c6c5),
      primaryFixed: Color(0xff494949),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff333232),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff4a4949),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff333232),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff225400),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff163b00),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffbbb8b7),
      surfaceBright: Color(0xfffcf8f8),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff4f0ef),
      surfaceContainer: Color(0xffe5e2e1),
      surfaceContainerHigh: Color(0xffd7d4d3),
      surfaceContainerHighest: Color(0xffc9c6c5),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffc8c6c5),
      surfaceTint: Color(0xffc8c6c5),
      onPrimary: Color(0xff303030),
      primaryContainer: Color(0xff1f1f1f),
      onPrimaryContainer: Color(0xff888686),
      secondary: Color(0xffc9c6c5),
      onSecondary: Color(0xff313030),
      secondaryContainer: Color(0xff474646),
      onSecondaryContainer: Color(0xffb7b4b4),
      tertiary: Color(0xff88db56),
      onTertiary: Color(0xff153800),
      tertiaryContainer: Color(0xff54a322),
      onTertiaryContainer: Color(0xff030e00),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff141313),
      onSurface: Color(0xffe5e2e1),
      onSurfaceVariant: Color(0xffc4c7c8),
      outline: Color(0xff8e9192),
      outlineVariant: Color(0xff444748),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe5e2e1),
      inversePrimary: Color(0xff5f5e5e),
      primaryFixed: Color(0xffe5e2e1),
      onPrimaryFixed: Color(0xff1b1b1c),
      primaryFixedDim: Color(0xffc8c6c5),
      onPrimaryFixedVariant: Color(0xff474746),
      secondaryFixed: Color(0xffe5e2e1),
      onSecondaryFixed: Color(0xff1c1b1b),
      secondaryFixedDim: Color(0xffc9c6c5),
      onSecondaryFixedVariant: Color(0xff474646),
      tertiaryFixed: Color(0xffa3f86f),
      onTertiaryFixed: Color(0xff092100),
      tertiaryFixedDim: Color(0xff88db56),
      onTertiaryFixedVariant: Color(0xff215100),
      surfaceDim: Color(0xff141313),
      surfaceBright: Color(0xff3a3939),
      surfaceContainerLowest: Color(0xff0e0e0e),
      surfaceContainerLow: Color(0xff1c1b1b),
      surfaceContainer: Color(0xff201f1f),
      surfaceContainerHigh: Color(0xff2a2a2a),
      surfaceContainerHighest: Color(0xff353434),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffdedcdb),
      surfaceTint: Color(0xffc8c6c5),
      onPrimary: Color(0xff262626),
      primaryContainer: Color(0xff929090),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffdfdcdb),
      onSecondary: Color(0xff262525),
      secondaryContainer: Color(0xff929090),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xff9df269),
      onTertiary: Color(0xff0f2c00),
      tertiaryContainer: Color(0xff54a322),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff141313),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffdadddd),
      outline: Color(0xffafb2b3),
      outlineVariant: Color(0xff8d9191),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe5e2e1),
      inversePrimary: Color(0xff484848),
      primaryFixed: Color(0xffe5e2e1),
      onPrimaryFixed: Color(0xff111111),
      primaryFixedDim: Color(0xffc8c6c5),
      onPrimaryFixedVariant: Color(0xff363636),
      secondaryFixed: Color(0xffe5e2e1),
      onSecondaryFixed: Color(0xff111111),
      secondaryFixedDim: Color(0xffc9c6c5),
      onSecondaryFixedVariant: Color(0xff373636),
      tertiaryFixed: Color(0xffa3f86f),
      onTertiaryFixed: Color(0xff051500),
      tertiaryFixedDim: Color(0xff88db56),
      onTertiaryFixedVariant: Color(0xff183f00),
      surfaceDim: Color(0xff141313),
      surfaceBright: Color(0xff454444),
      surfaceContainerLowest: Color(0xff070707),
      surfaceContainerLow: Color(0xff1e1d1d),
      surfaceContainer: Color(0xff282828),
      surfaceContainerHigh: Color(0xff333232),
      surfaceContainerHighest: Color(0xff3e3d3d),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfff2efef),
      surfaceTint: Color(0xffc8c6c5),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffc4c2c2),
      onPrimaryContainer: Color(0xff0b0b0b),
      secondary: Color(0xfff3efee),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffc5c2c1),
      onSecondaryContainer: Color(0xff0b0b0b),
      tertiary: Color(0xffcbffa7),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xff85d752),
      onTertiaryContainer: Color(0xff030e00),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff141313),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffeef0f1),
      outlineVariant: Color(0xffc0c3c4),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe5e2e1),
      inversePrimary: Color(0xff484848),
      primaryFixed: Color(0xffe5e2e1),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffc8c6c5),
      onPrimaryFixedVariant: Color(0xff111111),
      secondaryFixed: Color(0xffe5e2e1),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffc9c6c5),
      onSecondaryFixedVariant: Color(0xff111111),
      tertiaryFixed: Color(0xffa3f86f),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xff88db56),
      onTertiaryFixedVariant: Color(0xff051500),
      surfaceDim: Color(0xff141313),
      surfaceBright: Color(0xff51504f),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff201f1f),
      surfaceContainer: Color(0xff313030),
      surfaceContainerHigh: Color(0xff3c3b3b),
      surfaceContainerHighest: Color(0xff484646),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.background,
    canvasColor: colorScheme.surface,
  );

  /// Custom Color 1
  static const customColor1 = ExtendedColor(
    seed: Color(0xff0bb622),
    value: Color(0xff00b46d),
    light: ColorFamily(
      color: Color(0xff006d40),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff00b46d),
      onColorContainer: Color(0xff003d22),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff006d40),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff00b46d),
      onColorContainer: Color(0xff003d22),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff006d40),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xff00b46d),
      onColorContainer: Color(0xff003d22),
    ),
    dark: ColorFamily(
      color: Color(0xff4fdf93),
      onColor: Color(0xff00391f),
      colorContainer: Color(0xff00b46d),
      onColorContainer: Color(0xff003d22),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xff4fdf93),
      onColor: Color(0xff00391f),
      colorContainer: Color(0xff00b46d),
      onColorContainer: Color(0xff003d22),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xff4fdf93),
      onColor: Color(0xff00391f),
      colorContainer: Color(0xff00b46d),
      onColorContainer: Color(0xff003d22),
    ),
  );

  List<ExtendedColor> get extendedColors => [customColor1];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
