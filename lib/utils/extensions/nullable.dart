extension NullableCheck on String? {
  get isNullOrEmpty => this?.isEmpty ?? true;
}