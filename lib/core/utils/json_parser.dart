class JsonParser {
  JsonParser._();

  static String string(dynamic value) {
    if (value == null) {
      return '';
    }

    return value.toString();
  }

  static int integer(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value) ?? 0;
    }

    return 0;
  }

  static double decimal(dynamic value) {
    if (value is double) {
      return value;
    }

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }

    return 0.0;
  }

  static bool boolean(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is String) {
      return value.toLowerCase() == 'true';
    }

    return false;
  }

  static int? many2OneId(dynamic value) {
    if (value is List && value.isNotEmpty) {
      final id = value.first;

      if (id is int) {
        return id;
      }

      if (id is num) {
        return id.toInt();
      }

      if (id is String) {
        return int.tryParse(id);
      }
    }

    return null;
  }

  static String many2OneName(dynamic value) {
    if (value is List && value.length > 1) {
      return value[1]?.toString() ?? '';
    }

    return '';
  }

  static String? nullableString(dynamic value) {
    if (value == null) {
      return null;
    }

    return value.toString();
  }

  static int? nullableInteger(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }
}
