import 'dart:collection';

class LRUCache<K, V> {
  final int maxSize;
  final LinkedHashMap<K, V> _cache = LinkedHashMap();

  LRUCache({required this.maxSize});

  V? get(K key) {
    final value = _cache[key];
    if (value != null) {
      _cache.remove(key);
      _cache[key] = value;
    }
    return value;
  }

  void put(K key, V value) {
    if (_cache.length >= maxSize) {
      _cache.remove(_cache.keys.first);
    }
    _cache[key] = value;
  }

  List<K> getKeys(){
    return _cache.keys.toList();
  }

  bool containsKey(K key){
    return _cache.containsKey(key);
  }
}