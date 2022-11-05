List<T> deriveListFromMap<T>(dynamic data, T Function(Map<String, dynamic>) mapper) =>
    List<dynamic>.from((data as List<dynamic>?) ?? <dynamic>[])
        .map((dynamic e) => mapper(e as Map<String, dynamic>))
        .toList();
