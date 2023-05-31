import 'dart:html';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:async';

import 'package:sokoban/Levels.dart';

//La classe contenant les images chargées en mémoire
class Ressources {
  //Les images nécessaires au jeu, doivent se trouver dans les assets
  ui.Image? player; //un des sprites du joueur
  ui.Image? crate; //le sprite d'une caisse
  ui.Image? hole; //le sprite d'un trou
  ui.Image? wall;
  ui.Image? ground;
  ui.Image? objective;
  bool prepared = false;

  //Lance le chargement asynchrone des images
  Future<void> prepare() async {
    player = await _loadImage('assets/sprites/droite_0.png');
    crate = await _loadImage('assets/sprites/caisse.png');
    hole = await _loadImage('assets/sprites/trou.png');
    wall = await _loadImage('assets/sprites/trou.png');
    ground = await _loadImage('assets/sprites/trou.png');
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
class MyPainter extends CustomPainter {
  double height;
  double width;
  Ressources ressources;
  LevelManager levelManager = LevelManager(levelsPath: 'assets/levels.json');

  MyPainter(this.height, this.width, this.ressources);

  @override
  void paint(Canvas canvas, Size size) {
    //Si les ressources ne sont pas prêtes, ou qu'il y a un problème, on sort de la fonction
    if ((levelManager.levels == null) || (!ressources.prepared) ||(ressources.player==null)||(ressources.crate==null)) return;

    late final currentLevel = levelManager.levels![levelManager.currentLevel];

    Rect srcRect = const Rect.fromLTWH(0, 0, 128, 128);
    late ui.Image? img;

    for(int i = 0; i < currentLevel.height; ++i)
    {
      for(int j = 0; j < currentLevel.blocsGrid[i].length; ++j)
      {
        double xLocation = (j * height/currentLevel.height) as double;
        double yLocation = (i * width/currentLevel.width) as double;
        Rect destRect = Rect.fromLTWH(xLocation, yLocation, height/currentLevel.height, width/currentLevel.width);
        //Rect destRect = Rect.fromLTWH(xLocation, yLocation, height/currentLevel.height, width/currentLevel.width);

        switch(currentLevel.blocsGrid[i][j].bloc)
        {
          case BlocType.EMPTY:
            img = ressources.hole;
            break;
          case BlocType.BOX:
            img = ressources.crate;
            break;
          case BlocType.HOLE:
            img = ressources.hole;
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
        }
        //img = ressources.crate;
        canvas.drawImageRect(img!, srcRect, destRect, Paint());

      }
    }
    //On dessine 2 sprites  aux coins de l'écran
    //Rect srcRect = Rect.fromLTWH(0, 0, 128, 128); //On prend tout le sprites (128x128 pixels)
    //Rect destRect1 = Rect.fromLTWH(0, 0, 50, 50); //On affichera le premier sprite en haut à gauche, dans un carré de 50x50 pixels
    //Rect destRect2 = Rect.fromLTWH(width-50, height-50, 50, 50); //On affichera le deuxième sprite en bas à droite, dans un carré de 50x50 pixels
    //Rect destRect3 = Rect.fromLTWH((width-50)/2, (height-50)/2, 50, 50); //On affichera un carré bleu en plein milieu de l'écran

    //canvas.drawImageRect(ressources.player!, srcRect, destRect1, Paint());
    //canvas.drawImageRect(ressources.crate!, srcRect, destRect2, Paint());

    Paint paint = Paint();
    paint.color = Colors.blue;
    //canvas.drawRect(destRect3, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
