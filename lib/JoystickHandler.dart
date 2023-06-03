import 'package:flutter/cupertino.dart';
import 'package:sokoban/Levels.dart';
import 'package:arrow_pad/arrow_pad.dart';

class JoystickHandler extends StatelessWidget
{
  final movePlayerCallback;
  JoystickHandler({required this.movePlayerCallback});
  int direction = DirectionType.IDLE;
  @override
  Widget build(BuildContext context)
  {
   return ArrowPad(
      height: (MediaQuery.of(context).size.height-56-24) / 5,
      width: MediaQuery.of(context).size.width / 5,
      onPressed: (direction) => {onJoystickMoved(direction.toString())},
    );
  }
  void onJoystickMoved(String directionStr)
  {
    direction = directionStr == "up" ? DirectionType.UP :
    directionStr == "down" ? DirectionType.DOWN :
    directionStr == "right" ? DirectionType.RIGHT :
    directionStr == "left" ? DirectionType.LEFT :
    DirectionType.IDLE;

    if (direction != DirectionType.IDLE)
      movePlayerCallback(direction);
  }
}