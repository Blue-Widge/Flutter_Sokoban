import 'package:flutter/material.dart';

class Display extends StatefulWidget
{

  Display();
  @override
  State<StatefulWidget> createState() => _Display();
}

class _Display extends State<Display>
{
  late Widget toDisplay;

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
      toDisplay = Container(child: Text("test"),);
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
                onPressed: continueCallBack,
                label: const Text("Select level"),
                icon: const Icon(Icons.checklist_rounded),
                backgroundColor: Colors.deepOrangeAccent,
                foregroundColor: Colors.white,
              ),
            ])
    );
  }

}




