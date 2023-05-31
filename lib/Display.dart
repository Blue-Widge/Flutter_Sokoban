import 'package:flutter/material.dart';
import 'ImagesLoader.dart';
class Display extends StatefulWidget
{

  Display();
  @override
  State<StatefulWidget> createState() => _Display();
}

class _Display extends State<Display>
{
  late Widget toDisplay;
  Ressources ressources = Ressources(); //Sert au chargement des images en mémoire

  _Display()
  {
    ressources.prepare().then((value) => setState((){})); //Une fois les images chargées, on actualise
  }

  void newGameCallBack()
  {
    setState(() {
      toDisplay = Container(child: Text("test"),);
    });
  }
  void continueCallBack()
  {
    setState(() {
      toDisplay = Container(child: Text("test"),);
    });
  }
  void selectLevelCallBack()
  {
    setState(() {
      toDisplay = CustomPaint(
          painter:MyPainter(MediaQuery.of(context).size.height-56-24, MediaQuery.of(context).size.width, ressources)
      );
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



