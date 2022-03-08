String numberShortener(int number) {
  double abbreviatedNumber =
      double.parse(_abbreviateNumber(number).toStringAsFixed(1));
  if (abbreviatedNumber.floor() == abbreviatedNumber) {
    return abbreviatedNumber.floor().toString() +
        _getNumberAbbreviation(number);
  }
  return abbreviatedNumber.toStringAsFixed(1) + _getNumberAbbreviation(number);
}

double _abbreviateNumber(int number) {
  if (number < 1000) {
    return number.toDouble();
  }
  if (number < 1000000) {
    return (number / 1000);
  }
  if (number < 1000000000) {
    return (number / 1000000);
  }
  return (number / 1000000000);
}

String _getNumberAbbreviation(int number) {
  if (number < 1000) {
    return '';
  }
  if (number < 1000000) {
    return 'K';
  }
  if (number < 1000000000) {
    return 'M';
  }
  return 'B';
}
