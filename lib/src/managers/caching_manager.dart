import '../internal/constants.dart';
import '../internal/plugin.dart';
import '../types/entity.dart';
import '../types/thumb_option.dart';

/// The cache manager that helps to create/remove caches with specified assets.
class PhotoCachingManager {
  factory PhotoCachingManager() => instance;

  PhotoCachingManager._();

  static late final PhotoCachingManager instance = PhotoCachingManager._();

  static const ThumbOption _defaultOption = ThumbOption(
    width: PMConstants.vDefaultThumbnailSize,
    height: PMConstants.vDefaultThumbnailSize,
  );

  /// Request caching for assets.
  Future<void> requestCacheAssets({
    required List<AssetEntity> assets,
    ThumbOption option = _defaultOption,
  }) {
    assert(assets.isNotEmpty);
    return plugin.requestCacheAssetsThumb(
      assets.map((AssetEntity e) => e.id).toList(),
      option,
    );
  }

  /// Request caching for assets' ID.
  Future<void> requestCacheAssetsWithIds({
    required List<String> assetIds,
    ThumbOption option = _defaultOption,
  }) {
    assert(assetIds.isNotEmpty);
    return plugin.requestCacheAssetsThumb(assetIds, option);
  }

  /// Cancel all cache request.
  Future<void> cancelCacheRequest() => plugin.cancelCacheRequests();
}
