class Historique {
  final int? id;
  final String category;
  final String difficulty;
  final int score;
  final String date;
  final int userId;

  Historique({
    this.id,
    required this.category,
    required this.difficulty,
    required this.score,
    required this.date,
    required this.userId,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'category': category,
        'difficulty': difficulty,
        'score': score,
        'date': date,
        'userId': userId,
      };

  static Historique fromMap(Map<String, dynamic> map) => Historique(
        id: map['id'],
        category: map['category'],
        difficulty: map['difficulty'],
        score: map['score'],
        date: map['date'],
        userId: map['userId'],
      );
}
