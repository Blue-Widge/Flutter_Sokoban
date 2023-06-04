# Sokoban

Sokoban game using Android Studio with Flutter.

Devs : PRAUD Luan & LEMAIRE Yann

Packages used : hive, arrow_pad: ^0.2.0, audioplayers: ^4.1.0
The game begins on a menu where you can choose to either start a new game, continue where you were or select a level
Once in game you move with the arrow pad on the bottom right of the screen. You can zoom and pan on the map to inspect it.
On the top left you can reset the map, and on the top right you can undo your moves, limited to an amount of 100 moves, or return to the menu.
Every moves are being stored in a locally stored database.

Small sounds were added, a step sound when you move and a BONK when you try to move but you can't
The entities are being coded so that you can easily add a new type of bloc, make them oversteppable or not, etc.
The player can move multiple boxes along an axis, but it's a choice. if you don't want to you can delete the OR statement in Entity.dart at line 45 and keep obstacle.oversteppable

Animations are being rendered when the player moves -> the player sprite changes at tried move
A movement counter has been added to keep track of your score on the level
Once you finish a level, the famous happy wheels victory soundtrack plays

The gameData.g.dart file is a required generated adaptor for the database, if you suppress it you'll need to rerun the hive command :
```
flutter packages pub run build_runner build
```