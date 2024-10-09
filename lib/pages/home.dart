import 'package:flutter/material.dart';
import 'package:pizzaapp/auth/authprovider.dart';
import 'package:pizzaapp/models/pizza/pizzalist.dart';
import 'package:pizzaapp/pages/cartpage.dart';
import 'package:pizzaapp/pages/menupage.dart';
import 'package:pizzaapp/pages/profil/profilpage.dart';
import 'package:pizzaapp/widget/show_pizza_details.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const Home());
}

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  int _currentIndex = 0;
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              color: Colors.black, // Black background
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Text(
                      'Nos pizzas du moment',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255), // White text
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      itemCount: pizzaList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            showPizzaDetails(context, pizzaList[index]);
                          },
                          child: Card(
                            color: Colors.white,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              width: 180,
                              padding: const EdgeInsets.all(5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset(
                                  pizzaList[index].image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 0), // Increased space

            // Nouvelle section "Famiglia"
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.black,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/photo/famille_very.png',
                    height: 150,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'La Storia LA FAMIGLIA VERAMENTE',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Essere molto significa amare la vita con tutto ciò che ha di più gioia da offrirci. Dalle avventure più folli, ai momenti più difficili...',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // logique pour le bouton "En savoir plus" a rajouter => , tutto può succedere, purché la famiglia non sia mai troppo lontana...
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10), // Padding added
                    ),
                    child: const Text(
                      'En savoir plus',
                      style: TextStyle(color: Colors.black), // Text color
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20), // Increased space

            // Section "I NOSTRI PRODOTTI"
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white, // White background
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'I NOSTRI PRODOTTI',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Text color
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Tutte le nostre verdure sono locali e consegnate ogni giorno da un\'azienda di Montpellier; Pizzeria ciao ciao è fondamentale per far funzionare le imprese locali',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 20),

                  // Trois photos alignment horizontale with some padding
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Image.asset(
                            'assets/images/photo/farine.jpg',
                            height: 110,
                            width: 130,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Image.asset(
                            'assets/images/photo/mozza.png',
                            height: 110,
                            width: 130,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Image.asset(
                            'assets/images/photo/chorizo.png',
                            height: 110,
                            width: 130,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const MenuPage(),
      const ProfileTab(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'pizzApp',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBodyBehindAppBar: false,
        appBar: _currentIndex == 2
            ? null
            : AppBar(
                title: Image.asset(
                  'assets/images/ciaoPizza.jpg',
                  height: 60,
                ),
                backgroundColor: Colors.black,
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartPage(
                            cartItems: cartItems,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
        body: _currentIndex == 2 ? const ProfileTab() : pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: Colors.white, // Couleur des éléments sélectionnés
          unselectedItemColor: Colors.grey.shade400, // Couleur des éléments non sélectionnés
          backgroundColor: Colors.black, // Fond de la barre
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Accueil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu_outlined),
              label: 'Pizzas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return authProvider.isLoggedIn
        ? ProfilPage(
            user: authProvider.user,
            userProfile: const {},
            userProvider: null,
          )
        : const Center(
            child: Text('Connectez-vous pour voir votre profil'),
          );
  }
}
