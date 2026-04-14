import 'drop_state.dart';

class Raindrop {
  Raindrop({
    required this.x,
    required this.y,
    required this.w,
    required this.h,
    required this.rotation,
    required this.state,
    required this.opacity,
    required this.life,
    required this.vx,
    required this.vy,
  });

  double x;
  double y;
  double w;
  double h;
  double rotation;
  double opacity;
  double life;
  double vx;
  double vy;
  DropState state;
}
