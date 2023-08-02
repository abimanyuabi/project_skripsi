/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImgGen {
  const $AssetsImgGen();

  $AssetsImgPngGen get png => const $AssetsImgPngGen();
  $AssetsImgSvgGen get svg => const $AssetsImgSvgGen();
}

class $AssetsImgPngGen {
  const $AssetsImgPngGen();

  /// File path: assets/img/png/feeding_mode.png
  AssetGenImage get feedingMode =>
      const AssetGenImage('assets/img/png/feeding_mode.png');

  /// File path: assets/img/png/light_mode.png
  AssetGenImage get lightMode =>
      const AssetGenImage('assets/img/png/light_mode.png');

  /// File path: assets/img/png/wave_mode.png
  AssetGenImage get waveMode =>
      const AssetGenImage('assets/img/png/wave_mode.png');

  /// List of all assets
  List<AssetGenImage> get values => [feedingMode, lightMode, waveMode];
}

class $AssetsImgSvgGen {
  const $AssetsImgSvgGen();

  /// File path: assets/img/svg/feeding_mode_asset.svg
  String get feedingModeAsset => 'assets/img/svg/feeding_mode_asset.svg';

  /// File path: assets/img/svg/light_mode_asset.svg
  String get lightModeAsset => 'assets/img/svg/light_mode_asset.svg';

  /// File path: assets/img/svg/logo.svg
  String get logo => 'assets/img/svg/logo.svg';

  /// File path: assets/img/svg/wave_mode_asset.svg
  String get waveModeAsset => 'assets/img/svg/wave_mode_asset.svg';

  /// List of all assets
  List<String> get values =>
      [feedingModeAsset, lightModeAsset, logo, waveModeAsset];
}

class Assets {
  Assets._();

  static const $AssetsImgGen img = $AssetsImgGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
