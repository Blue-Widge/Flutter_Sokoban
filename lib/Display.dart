import 'package:flutter/material.dart';

class Display extends StatefulWidget
{

  Display();
  @override
  State<StatefulWidget> createState() => _Display();
}

class _Display extends State<Display>
{
  Widget? toDisplay;

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
    return Container(
      child: toDisplay,
    );
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: newGameCallBack, child: const Text("New game")),
          SizedBox(height: 10),
          ElevatedButton(onPressed: continueCallBack, child: const Text("Continue")),
          SizedBox(height: 10),
          ElevatedButton(onPressed: selectLevelCallBack, child: const Text("Select level")),

        ]);
  }

}




