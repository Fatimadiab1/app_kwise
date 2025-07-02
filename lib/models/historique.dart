class Historique {
  final int? id;
  final String category;
  final String difficulty;
  final int score;
  final String date;

  Historique({
    this.id,
    required this.category,
    required this.difficulty,
    required this.score,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'difficulty': difficulty,
      'score': score,
      'date': date,
    };
  }

  factory Historique.fromMap(Map<String, dynamic> map) {
    return Historique(
      id: map['id'],
      category: map['category'],
      difficulty: map['difficulty'],
      score: map['score'],
      date: map['date'],
    );
  }
}
