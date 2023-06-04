import 'package:flutter/material.dart';
import 'LevelsDb.dart';
import 'BoxDb.dart';
import 'ImagesLoader.dart';
import 'Levels.dart';
import 'JoystickHandler.dart';

class Display extends StatefulWidget
{
  final LevelManager levelManager;
  Display({required this.levelManager});
  @override
  State<StatefulWidget> createState() => _Display(levelManager: levelManager);
}

class _Display extends State<Display>
{
  late LevelManager levelManager;
  late Widget toDisplay;
  MovementSaver movementSaver = MovementSaver();
  Ressources ressources = Ressources(); //Sert au chargement des images en mémoire
  final TransformationController _transformController = TransformationController();

  _Display({required this.levelManager})
  {
    ressources.prepare().then((value) => setState((){})); //Une fois les images chargées, on actualise
  }

  void newGameCallBack()
  {
    boxDb.clear;
    levelManager.chargeLevel(0);
    levelManager.getCurrentLevel().resetLevel();
    displayLevel(levelManager.currentLevel);
  }
  void continueCallBack()
  {
    String key = 'key_level_${levelManager.currentLevel.toString()}';
    LevelsDb level = boxDb.get(key);
    if (levelManager.currentLevel != 0 || TempGameData.moved)
      levelManager.chargeLevel(levelManager.currentLevel);
    setState(()
    {
      displayLevel(levelManager.currentLevel);
    });
  }
  void selectLevelCallBack()
  {
    int nbLevels = levelManager.getNumberOfLevels();
    List<Widget> buttons = List.generate(nbLevels, (index) =>
        FloatingActionButton.extended(
          onPressed: ()
          {
            levelManager.chargeLevel(index);
            levelManager.getCurrentLevel().resetLevel();
            boxDb.clear();
            displayLevel(index);
          },
          extendedPadding: EdgeInsets.all(30),
          label: Text("Level $index"),
          icon: const Icon(Icons.play_arrow),
          backgroundColor: Colors.deepOrangeAccent,
          foregroundColor: Colors.white,)
      );
    setState(() {
      toDisplay = Container(
        color: Colors.black26,
        child: SingleChildScrollView(
          child: Wrap(
            direction: Axis.vertical,
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            spacing: 20,
            runSpacing: 20,
            children: buttons,
          )
        ),
      );
    });
  }

  void displayLevel(int levelNumber)
  {
    setState(() {
      toDisplay = Container(
          color: Colors.black87,
          child: Stack(
            alignment: Alignment.bottomLeft,
            fit: StackFit.passthrough,
            children: [
              InteractiveViewer(
                  boundaryMargin: EdgeInsets.all(50.0 * levelManager.getCurrentLevel().width / _transformController.value.getMaxScaleOnAxis()),
                  minScale: 0.25,
                  maxScale: 2.5,
                  child: CustomPaint(
                      painter:MyPainter(MediaQuery.of(context).size.height-56-24, MediaQuery.of(context).size.width, ressources, levelManager)
                  )
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: JoystickHandler(movePlayerCallback: joystickCallBack),
              ),
              Align(
                alignment: Alignment.topRight,
                child: FloatingActionButton.extended(
                  onPressed: () => setState(()
                  {
                    toDisplay = Menu(newGameCallBack, continueCallBack, selectLevelCallBack);
                  }),
                  backgroundColor: Colors.deepOrangeAccent,
                  foregroundColor: Colors.white,
                  label: const Text("Menu"),
                ),
              ),
            ],
          ),
      );
    });
  }

  void joystickCallBack(int direction)
  {
    setState(() {
      AnimationStep.animationStep = (AnimationStep.animationStep + 1) % 3;
      if(levelManager.getCurrentLevel().player!.moveEntity(direction, levelManager.currentLevel)){
        movementSaver.saveData(levelManager.currentLevel, direction);
      }
    });
  }

  @override
  void initState()
  {
    super.initState();
    toDisplay = Menu(newGameCallBack, continueCallBack, selectLevelCallBack);
  }

  @override
  Widget build(BuildContext context)
  {
      return toDisplay;
  }
}

class TempGameData
{
  static bool _hasMoved = false;
  static get moved => _hasMoved;
}

class Menu extends StatelessWidget
{
  VoidCallback newGameCallBack;
  VoidCallback continueCallBack;
  VoidCallback selectLevelCallBack;

  Menu(this.newGameCallBack, this.continueCallBack, this.selectLevelCallBack);

  @override
  Widget build(BuildContext context)
  {
    return Container(
        color: Colors.black26,
        child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton.extended(
                onPressed: newGameCallBack,
                label: const Text("New game"),
                icon: const Icon(Icons.add),
                backgroundColor: Colors.deepOrangeAccent,
                foregroundColor: Colors.white,
              ),
              const SizedBox(height: 10),
              FloatingActionButton.extended(
                onPressed: continueCallBack,
                label: const Text("Continue"),
                icon: const Icon(Icons.play_arrow),
                backgroundColor: Colors.deepOrangeAccent,
                foregroundColor: Colors.white,
              ),
              const SizedBox(height: 10),
              FloatingActionButton.extended(
                onPressed: selectLevelCallBack,
                label: const Text("Select level"),
                icon: const Icon(Icons.checklist_rounded),
                backgroundColor: Colors.deepOrangeAccent,
                foregroundColor: Colors.white,
              ),
            ])
    );
  }
}