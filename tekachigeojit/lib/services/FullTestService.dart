class FullTestService {
  static final FullTestService _instance = FullTestService._internal();

  factory FullTestService() {
    return _instance;
  }

  FullTestService._internal();

  int? _aptitudeScore;
  String? _technicalVerdict;
  String? _hrVerdict;

  void setAptitudeScore(int score) {
    _aptitudeScore = score;
  }

  void setTechnicalVerdict(String verdict) {
    _technicalVerdict = verdict;
  }

  void setHRVerdict(String verdict) {
    _hrVerdict = verdict;
  }

  int getAptitudeScore() {
    return _aptitudeScore ?? 0;
  }

  String getTechnicalVerdict() {
    return _technicalVerdict ?? 'Not evaluated';
  }

  String getHRVerdict() {
    return _hrVerdict ?? 'Not evaluated';
  }
}
