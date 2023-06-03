import 'package:flutter/material.dart';
import 'package:sokoban/Entity.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:async';

import 'Levels.dart';

//La classe contenant les images chargées en mémoire
class Ressources {
  //Les images nécessaires au jeu, doivent se trouver dans les assets
  List<ui.Image?>? playerSprites; //un des sprites du joueur
  ui.Image? crate; //le sprite d'une caisse
  ui.Image? hole; //le sprite d'un trou
  ui.Image? wall;
  ui.Image? ground;
  ui.Image? objective;
  bool prepared = false;

  //Lance le chargement asynchrone des images
  Future<void> prepare() async
  {
    List<String> test = List.empty(growable: true);
    playerSprites = await Future.wait(List<Future<ui.Image>>.generate(DirectionType.IDLE * 3, (direction)
      {
        String? frDirection;
        int spriteIndex = direction % 3;
        switch(direction ~/ 3)
        {
          case DirectionType.UP:
            frDirection = "haut";
            break;
          case DirectionType.RIGHT:
            frDirection = "droite";
            break;
          case DirectionType.DOWN:
            frDirection = "bas";
            break;
          case DirectionType.LEFT:
            frDirection = "gauche";
            break;
        }
        test.add("assets/sprites/${frDirection}_${spriteIndex}.png");
        return _loadImage('assets/sprites/${frDirection}_${spriteIndex}.png');
      })
    );
    crate = await _loadImage('assets/sprites/caisse.png');
    hole = await _loadImage('assets/sprites/trou.png');
    wall = await _loadImage('assets/sprites/bloc.png');
    ground = await _loadImage('assets/sprites/sol.png');
    objective = await _loadImage('assets/sprites/cible.png');
    prepared = true;
  }

  //Fonction de transformation d'une image asset en une image dessinable dans un canvas
  //Vous pouvez l'utiliser directement, pas besoin de la modifier pour votre projet
  Future<ui.Image> _loadImage(String fichier) async {
    ExactAssetImage assetImage = ExactAssetImage(fichier);

    AssetBundleImageKey key = await assetImage.obtainKey(ImageConfiguration());

    final ByteData data = await key.bundle.load(key.name);

    if (data == null)
      throw 'Impossible de récupérer l\'image $fichier';

    var codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    var frame = await codec.getNextFrame();

    return frame.image;
  }
}

//La zone de dessin
class MyPainter extends CustomPainter
{
  double height;
  double width;
  Ressources ressources;
  LevelManager levelManager;
  late int playerLastMove;

  MyPainter(this.height, this.width, this.ressources, this.levelManager)
  {
    playerLastMove = levelManager.getCurrentLevel().player!.currentMove;
  }

  @override
  void paint(Canvas canvas, Size size) {
    //Si les ressources ne sont pas prêtes, ou qu'il y a un problème, on sort de la fonction
    if ((levelManager.isLevelParsed() == false) || (!ressources.prepared) ||(ressources.playerSprites==null)||(ressources.crate==null)) return;
    Level currentLevel = levelManager.getCurrentLevel();

    Rect srcRect = const Rect.fromLTWH(0, 0, 128, 128);
    late ui.Image? img;

    for(int i = 0; i < currentLevel.height; ++i)
    {
      for(int j = 0; j < currentLevel.blocsGrid[i].length; ++j)
      {
        double xLocation = (j * 50) as double;
        double yLocation = (i * 50) as double;
        Rect destRect = Rect.fromLTWH(xLocation, yLocation, 50, 50);

        switch(currentLevel.blocsGrid[i][j].bloc)
        {
          case BlocType.EMPTY:
            continue;
          case BlocType.BOX:
            img = ressources.crate;
            break;
          case BlocType.WALL:
            img = ressources.wall;
            break;
          case BlocType.GROUND:
            img = ressources.ground;
            break;
          case BlocType.OBJECTIVE:
            img = ressources.objective;
            break;
          case BlocType.HOLE:
            img = ressources.hole;
            break;
          case BlocType.PLAYER:
            var player = levelManager.getCurrentLevel().player!;
            img = ressources.playerSprites![player.currentMove * 3 + AnimationStep.animationStep]!;
            playerLastMove = player.currentMove;
            switch((currentLevel.blocsGrid[i][j] as MovableEntity).onBloc)
            {
              case BlocType.OBJECTIVE:
                canvas.drawImageRect(ressources.objective!, srcRect, destRect, Paint());
                break;
              case BlocType.GROUND:
                default:
                canvas.drawImageRect(ressources.ground!, srcRect, destRect, Paint());
                break;
            }
        }
        canvas.drawImageRect(img!, srcRect, destRect, Paint());
      }
    }
    Paint();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class AnimationStep
{
  static int animationStep = 0;
}
