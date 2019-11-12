/// An instance of text to be re-cased.
class MkStringCase {
  MkStringCase(String text) {
    final StringBuffer sb = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      final String char = String.fromCharCode(text.codeUnitAt(i));
      final String nextChar = i + 1 == text.length ? null : String.fromCharCode(text.codeUnitAt(i + 1));

      if (_symbolRegex.hasMatch(char)) {
        continue;
      }

      sb.write(char);

      if (nextChar == null ||
          (_lowerAlphaRegex.hasMatch(char) && _upperAlphaRegex.hasMatch(nextChar)) ||
          _symbolRegex.hasMatch(nextChar)) {
        this._words.add(sb.toString());
        sb.clear();
      }
    }
  }

  final RegExp _lowerAlphaRegex = RegExp(r'[a-z]');
  final RegExp _upperAlphaRegex = RegExp(r'[A-Z]');
  final RegExp _symbolRegex = RegExp(r'[ ./_\-]');

  final List<String> _words = [];

  String _upperCaseFirstLetter(String word) {
    return '${word.substring(0, 1).toUpperCase()}${word.substring(1).toLowerCase()}';
  }

  // snake_case
  String _getSnakeCase({String separator = '_'}) {
    final List<String> words = this._words.map((word) => word.toLowerCase()).toList();

    return words.join(separator);
  }

  // PascalCase
  String _getPascalCase({String separator = ''}) {
    final List<String> words = this._words.map(_upperCaseFirstLetter).toList();

    return words.join(separator);
  }

  // CONSTANT_CASE
  String _getConstantCase({String separator = '_'}) {
    final List<String> words = this._words.map((word) => word.toUpperCase()).toList();

    return words.join(separator);
  }

  // camelCase
  String _getCamelCase({String separator = ''}) {
    final List<String> words = this._words.map(_upperCaseFirstLetter).toList();
    if (words.isNotEmpty) {
      words[0] = words[0].toLowerCase();
    }

    return words.join(separator);
  }

  // Sentence case
  String _getSentenceCase({String separator = ' '}) {
    final List<String> words = this._words.map((word) => word.toLowerCase()).toList();
    if (words.isNotEmpty) {
      words[0] = _upperCaseFirstLetter(words[0]);
    }

    return words.join(separator);
  }

  /// The input text rendered as snake_case
  String get snakeCase => _getSnakeCase();

  /// The input text rendered as dot.case
  String get dotCase => _getSnakeCase(separator: '.');

  /// The input text rendered as path/case
  String get pathCase => _getSnakeCase(separator: '/');

  /// The input text rendered as param-case
  String get paramCase => _getSnakeCase(separator: '-');

  /// The input text rendered as PascalCase
  String get pascalCase => _getPascalCase();

  /// The input text rendered as Header-Case
  String get headerCase => _getPascalCase(separator: '-');

  /// The input text rendered as Title Case
  String get titleCase => _getPascalCase(separator: ' ');

  /// The input text rendered as camelCase
  String get camelCase => _getCamelCase();

  /// The input text rendered as Sentence case
  String get sentenceCase => _getSentenceCase();

  /// The input text rendered as CONSTANT_CASE
  String get constantCase => _getConstantCase();
}
