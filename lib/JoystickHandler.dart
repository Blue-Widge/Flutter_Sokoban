import 'package:flutter/cupertino.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:sokoban/Levels.dart';

class JoystickHandler extends StatefulWidget
{
  double distanceThreshold = 0.5;
  final movePlayerCallback;
  JoystickHandler({required this.movePlayerCallback, double? distance}) {distanceThreshold = distance!;}

  @override
  State<StatefulWidget> createState() => _JoystickHandlerState(distanceThreshold: distanceThreshold, movePlayerCallback: movePlayerCallback);
}

class _JoystickHandlerState extends State<JoystickHandler>
{
  final double distanceThreshold;
  int direction = DirectionType.IDLE;
  final movePlayerCallback;

  _JoystickHandlerState({required this.distanceThreshold, required this.movePlayerCallback});

  onJoystickMoved(StickDragDetails details)
  {
    direction = details.y > distanceThreshold ? DirectionType.UP :
        -details.y > distanceThreshold ? DirectionType.DOWN :
        details.x > distanceThreshold ? DirectionType.RIGHT :
        -details.x > distanceThreshold ? DirectionType.LEFT :
        DirectionType.IDLE;

    if (direction != DirectionType.IDLE)
      setState((){ movePlayerCallback(direction); });
  }

  @override
  Widget build(BuildContext context) 
  {
    return Joystick( listener: onJoystickMoved );
  }
}