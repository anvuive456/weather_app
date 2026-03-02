/// Generic in-memory cache with TTL (Time-To-Live) support.
///
/// Cache entries expire automatically based on their TTL.
/// Stale entries are not proactively removed; they are evicted lazily on next [get].
class CacheManager {
  CacheManager();

  final Map<String, _CacheEntry<dynamic>> _store = {};

  /// Retrieves cached value for [key].
  /// Returns `null` if the entry does not exist or has expired.
  T? get<T>(String key) {
    final entry = _store[key];
    if (entry == null) return null;
    if (entry.isExpired) {
      _store.remove(key);
      return null;
    }
    return entry.data as T;
  }

  /// Stores [data] under [key] with the given [ttl].
  /// Overwrites any existing entry for [key].
  void set<T>(String key, T data, Duration ttl) {
    _store[key] = _CacheEntry<T>(data: data, ttl: ttl);
  }

  /// Removes the entry for [key] regardless of expiry.
  void invalidate(String key) {
    _store.remove(key);
  }

  /// Removes all entries whose key satisfies [test].
  void invalidateWhere(bool Function(String key) test) {
    _store.removeWhere((key, _) => test(key));
  }

  /// Removes all entries from the cache.
  void clear() {
    _store.clear();
  }

  /// Returns `true` if there is a non-expired entry for [key].
  bool has(String key) => get(key) != null;

  /// Number of entries currently in the cache (including expired).
  int get length => _store.length;
}

class _CacheEntry<T> {
  final T data;
  final DateTime _cachedAt;
  final Duration ttl;

  _CacheEntry({required this.data, required this.ttl})
      : _cachedAt = DateTime.now();

  bool get isExpired => DateTime.now().difference(_cachedAt) > ttl;

  /// Remaining time before this entry expires.
  Duration get remainingTtl {
    final elapsed = DateTime.now().difference(_cachedAt);
    final remaining = ttl - elapsed;
    return remaining.isNegative ? Duration.zero : remaining;
  }
}
