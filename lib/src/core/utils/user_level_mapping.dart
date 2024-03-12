import 'dart:math' as math;

class UserLevel {
  final String title;
  final String imagePath;

  UserLevel(this.title, this.imagePath);
}

UserLevel mapScoreToLevel({required double score}) {
  final levels = [
    UserLevel('Beginner', 'assets/gifs/sargent.gif'),
    UserLevel('Amateur', 'assets/gifs/throphy.gif'),
    UserLevel('Intermediate', 'assets/gifs/gem.gif'),
    UserLevel('Advanced', 'assets/images/advanced.png'),
    UserLevel('Expert', 'assets/images/expert.png'),
    UserLevel('Master', 'assets/images/master.png'),
    UserLevel('Grandmaster', 'assets/images/grandmaster.png'),
    UserLevel('Legend', 'assets/images/legend.png'),
    UserLevel('Mythical', 'assets/images/mythical.png'),
    UserLevel('Godlike', 'assets/images/godlike.png'),
  ];
  return levels[math.min<int>(levels.length - 1, (score / 100).floor())];
}
