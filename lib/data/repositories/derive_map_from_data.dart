Map<String, T> deriveMapFromMap<T>(dynamic data, T Function(dynamic) mapper) =>
    Map<String, dynamic>.from((data as Map<String, dynamic>?) ?? <String, dynamic>{}).map(
      (String key, dynamic value) => MapEntry<String, T>(key, mapper(value)),
    );
