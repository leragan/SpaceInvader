//////////////////////////////////////////////////////////////
//
// Les déclarations de variables
//
//////////////////////////////////////////////////////////////
import processing.sound.*;
SoundFile file;

final float speedBullet = 10;
final int gunHeight = 20;

// les coordonnées du canon
float gunX, gunY;
// les coordonnées du missile
ArrayList<Float> bulletX = new ArrayList<Float>();
ArrayList<Float> bulletY = new ArrayList<Float>(); //<>//


// les coordonnées de l'invader
float[][] invaderposition = { {60, 130, 200, 270, 340 }, {100,160},};
// le vecteur vitesse de l'invader
float invaderVx, invaderVy;

// est-ce qu'un missile a été tiré ?
boolean bullet; 
// est-ce que l'invader a été touché ?
boolean hit;

// est-ce que la partie est finie ?
boolean gameOver;
// le score et le meilleur score
int score, best;
// l'horloge
int clock;
// le nombre de ticks d'horloge entre 2 activations de l'invader
int clockPeriod;
// le temps pendant lequel l'invader touché change de couleur
int hitPeriod;

// les images de l'invader et du canon
PImage invader,invader2, gun;
// les polices pour le texte
PFont fonte16, fonte32;

//////////////////////////////////////////////////////////////
//
// La fonction d'initialisation
//
//////////////////////////////////////////////////////////////
void setup() {
  // fixe la taille de la fenêtre
  size(600, 800);
  // change les paramètres de dessin
  strokeWeight(3);
  // charge les images en mémoire
  invader = loadImage("invader2.png");
  invader2 = loadImage("invader3.png");
  gun = loadImage("gun.png");
  // les images seront centrées sur le point dont on donne les coordonnées
  imageMode(CENTER);

  // charge les polices de caractères en mémoire
  fonte16 = createFont("joystix.ttf", 16);
  fonte32 = createFont("joystix.ttf", 32);
  // initialise les paramètres pour l'affichage du texte
  textAlign(LEFT, CENTER); 
  textFont(fonte16);
  // au départ, pas de meilleur score
  best = 0;
  // 50 appels par seconde de la fonction draw
  frameRate(50);
  
 file = new SoundFile(this, "musique.mp3");
    file.loop();
  // appelle la fonction d'initialisation du jeu
  newGame();
}

//////////////////////////////////////////////////////////////
//
// La boucle de rendu
//
//////////////////////////////////////////////////////////////
void draw() {
  // incrémente l'horloge
  clock = (clock + 1) % clockPeriod;

  // le suivi du missile
  goBullet();
  // l'activation de l'invader
  goInvader();
  // le test de collision missile/invader
  testHit();

  // met à jour l'affichage
  repaint();
  // gestion de l'interaction
  control();
}

//////////////////////////////////////////////////////////////
//
// L'initialisation du jeu
//
//////////////////////////////////////////////////////////////
void newGame() {
  // la position du canon au centre de l'écran, en bas
  gunX = width / 2;
  gunY = height - gunHeight;
  // pas de missile tiré
  bullet = false;
  // la partie n'est pas finie
  gameOver = false;
  // position et vitesse de l'invader2
    invaderVx = 10;
  // paramètres d'horloge
  clock = 0;
  clockPeriod = 30;
  // score remis à 0
  score = 0;
  
}

//////////////////////////////////////////////////////////////
//
// Le tir d'un missile
//
//////////////////////////////////////////////////////////////
void fire() {
  // place le missile au bout du canon
  bulletX.add(gunX); 
  bulletY.add(gunY - 30);
  // un missile a été tiré
}

//////////////////////////////////////////////////////////////
//
// L'animation du missile
//
//////////////////////////////////////////////////////////////
void goBullet() {
    for (int i=0; i<bulletY.size(); i++) 
        bulletY.set(i,bulletY.get(i)- speedBullet);
          
}
 
//////////////////////////////////////////////////////////////
//
// L'animation de l'invader
//
//////////////////////////////////////////////////////////////
void goInvader() {
  // quand l'horloge revient à 0, on déplace l'invader horizontalement
  if (clock == 0) {
    for(int i=0; i<invaderposition[0].length; i++)
    invaderposition[0][i] = invaderposition[0][i] + invaderVx; //<>//
    
  }
  // gère le déplacement de l'invader quand il arrive à droite
for(int i=0; i<invaderposition.length; i++)
  if (invaderVx > 0) {
    if (invaderposition[0][4] > width - 50) {
      if (clockPeriod > 2)
        clockPeriod -= 2;
      invaderVx *= -1.1;
      invaderposition[1][0] +=25 ;
      invaderposition[1][1] += 25;
    }
  }
  // gère le déplacement de l'invader quand il arrive à gauche
  else if (invaderposition[0][0] < 50) {
    if (clockPeriod > 2)
      clockPeriod -= 2;
    invaderVx *= -1.1;
    invaderposition[1][0] += 25;
    invaderposition[1][1] += 25;
  }
  // la partie est finie quand l'invader arrive en bas
  if (invaderposition[1][1] >= height)
    gameOver = true;
}

//////////////////////////////////////////////////////////////
//
// La mise à jour de la fenêtre d'animation
// Cette fonction utilise notamment les fonctions :
// - drawGun pour afficher le canon
// - drawInvader pour afficher l'invader
// - drawBullet pour afficher le missile
//
//////////////////////////////////////////////////////////////
void repaint() {
  // fond de la fenêtre en blanc
  background(255);

  // affiche l'écran Game Over si la partie est finie
  if (gameOver) {
    gameOver();
  }
  // sinon affiche le jeu
  else {
    // affiche les éléments du jeu
    drawGun();
    drawBullet();
    drawInvader();
    drawScore();
  }
}

//////////////////////////////////////////////////////////////
//
// L'affichage du canon
//
//////////////////////////////////////////////////////////////
void drawGun() {
  // choisit la couleur
  tint(0);
  // affiche le canon
  image(gun, gunX, gunY);
}

//////////////////////////////////////////////////////////////
//
// L'affichage de l'invader
//
//////////////////////////////////////////////////////////////
void drawInvader() {
  // quand il est touché
  if (hit) {
    // il s'affiche en rouge
    tint(255, 0, 0);
    // pendant un certain temps
    hitPeriod--;
    if (hitPeriod == 0)
      hit = false;
  } else
    // sinon, il est bleu
    tint(39, 55, 147);
  // affiche l'invader
image(invader, invaderposition[0][0], invaderposition[1][0]);
image(invader, invaderposition[0][1], invaderposition[1][0]);
image(invader, invaderposition[0][2], invaderposition[1][0]);
image(invader, invaderposition[0][3], invaderposition[1][0]);
image(invader, invaderposition[0][4], invaderposition[1][0]);

image(invader2, invaderposition[0][0], invaderposition[1][1]);
image(invader2, invaderposition[0][1], invaderposition[1][1]);
image(invader2, invaderposition[0][2], invaderposition[1][1]);
image(invader2, invaderposition[0][3], invaderposition[1][1]);
image(invader2, invaderposition[0][4], invaderposition[1][1]);
 
}

//////////////////////////////////////////////////////////////
//
// L'affichage du missile
//
//////////////////////////////////////////////////////////////
void drawBullet() {
  // une simple ligne verticale
  for (int i=0; i<bulletY.size(); i++)
    line(bulletX.get(i), bulletY.get(i), bulletX.get(i), bulletY.get(i) - 10); 
  }


//////////////////////////////////////////////////////////////
//
// Teste si le missile percute l'invader
//
//////////////////////////////////////////////////////////////
void testHit() {
  // si le missile est dans la "boîte englobante" de l'invader  
  for (int j=0; j<invaderposition[0].length; j++)
  for (int i=0; i<bulletY.size(); i++){
    if ((bulletX.get(i) >= invaderposition[0][j] - 25) &&
      (bulletX.get(i) <= invaderposition[0][j] + 25) &&
      (bulletY.get(i) <= invaderposition[1][0] + 18) && 
      (bulletY.get(i) >= invaderposition[1][0] - 18) ||
      (bulletY.get(i) <= invaderposition[1][1] + 18) && 
      (bulletY.get(i) >= invaderposition[1][1] - 18)) {
              
      // met à jour le score  
      score++;
      if (score > best)
        best = score;
      // l'invader est touché
      hit = true;
      hitPeriod = 10;
      // il n'y a plus de missile lancé
      //bullet = false;
      // on le met de côté pour le cacher
      bulletX.set(i, new Float(-10));
    }
  }
}
//////////////////////////////////////////////////////////////
//
// L'affichage du score
//
//////////////////////////////////////////////////////////////
void drawScore() {
  // affiche le score
  fill(0);
  text("Score : " + score, width - 300, 20);
  text("Meilleur score : " + best, width - 300, 40);
  fill(255);
}

//////////////////////////////////////////////////////////////
//
// L'affichage du message "GAME OVER"
//
//////////////////////////////////////////////////////////////
void gameOver() {
  pushStyle();
  textAlign(CENTER, CENTER);
  textFont(fonte32);
  fill(0);
  text("GAME OVER !!!", width/2, height/2);
  textFont(fonte16);
  text("Appuyez sur espace pour recommencer", width/2, height/2 + 30);
  popStyle();
}

//////////////////////////////////////////////////////////////
//
// Pilote le canon et contrôle le lancement de missiles
//
//////////////////////////////////////////////////////////////
void control() {
  if (keyPressed) {
    if (key == CODED) {
      // quand on appuie sur la flèche droite
      if (keyCode == RIGHT) {
        if (gunX < width - 25)
          gunX+=5;
      }
      // quand on appuie sur la flèche gauche
      else if (keyCode == LEFT) {
        if (gunX > 25)
          gunX-=5;
      }
    }
    // quand on appuie sur la barre d'espace
    else if (key == ' ') {
      // relance une nouvelle partie si c'était gameOver
      if (gameOver) {
        gameOver = false;
        newGame();
      }
      // sinon tire un missile
      else {
           fire();
      }
    }
  }
}
