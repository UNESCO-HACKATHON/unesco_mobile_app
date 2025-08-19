class OverLayState {
  int height;
  bool? isExpaned;
  OverLayState({required this.height, this.isExpaned = false});

  OverLayState copyWith({int? height, bool? isExpaned}) {
    return OverLayState(height: height ?? this.height, isExpaned: isExpaned ?? this.isExpaned);
  }
}
