// Affichage de mes pizzes dans le MENU DES PIZZES 

class Pizze {
  final String name;
  final String image;
  final String description;
  final List<String>sizes;
  final List<double>prices;
  final bool isPizzaRose;
  List<String> addIngredients;
  final double addIngredientsPrices;

  Pizze ({
    required this.name,
    required this.image,
    required this.description,
    required this.prices,
    required this.sizes,
    required this.isPizzaRose,
    required this.addIngredients,
    required this.addIngredientsPrices,
  });
}

List<Pizze> pizzeList = [

  // Pizza rose
  Pizze(
    name: 'MARGHERITA',
    image: 'assets/images/nettuno.png',
    prices: [9.50, 11],
    sizes: ['26cm','31cm'],
    description: 'Sauce tomate, mozzarella FDL, basilic frais, huile d\'olive',
    isPizzaRose: true,
    addIngredients: ['Tomate', 'Basilic', 'roquette', 'parmesan'],
    addIngredientsPrices: 0.50,
  ),
  Pizze(
    name: 'DIAVOLA',
    image: 'assets/images/nettuno.png',
    prices: [14.00, 16.00],
    sizes: ['26cm','31cm'],
    description: 'Sauce tomate, mozzarella di bufala, ventricina salami italien relevé, basilic frais, origan',
    isPizzaRose: true,
    addIngredients: ['Tomate', 'Basilic', 'roquette', 'parmesan'],
    addIngredientsPrices: 0.50,
  ),
  Pizze(
    name: 'NAPOLETANA',
    image: 'assets/images/nettuno.png',
    prices: [12.00, 14.00],
    sizes: ['26cm','31cm'],
    description: 'Sauce tomate, mozzarella FDL, anchois, câpres, olives, huile d\'olive',
    isPizzaRose: true,
    addIngredients: ['Tomate', 'Basilic', 'roquette', 'parmesan'],
    addIngredientsPrices: 0.50,
  ),
  Pizze(
    name: 'MAMMA MIA',
    image: 'assets/images/nettuno.png',
    prices: [13.00,	15.00],
    sizes: ['26cm','31cm'],
    description: 'Sauce tomate, mozzarella FDL, jambon blanc, gorgonzola, filet de crème fraîche',
    isPizzaRose: true,  
    addIngredients: ['Tomate', 'Basilic', 'roquette', 'parmesan'],
    addIngredientsPrices: 0.50,
  ),
  Pizze(
    name: '4 STAGIONI',
    image: 'assets/images/nettuno.png',
    prices: [14.50, 16.50],
    sizes: ['26cm','31cm'],
    description: 'Sauce tomate, mozzarella FDL, champignons, jambon blanc, artichauts à la romaine, olives',
    isPizzaRose: true,
    addIngredients: ['Tomate', 'Basilic', 'roquette', 'parmesan'],
    addIngredientsPrices: 0.50,
  ),
  Pizze(
    name: 'NETTUNO',
    image: 'assets/images/nettuno.png',
    prices: [14.00,	16.00],
    sizes: ['26cm','31cm'],
    description: 'Sauce tomate, mozzarella FDL, tomates semi-séchées, oignons rouges, thon, câpres, olives taggiasche',
    isPizzaRose: true,
    addIngredients: ['Tomate', 'Basilic', 'roquette', 'parmesan'],
    addIngredientsPrices: 0.50,
  ),

  // Pizza bianchi 
  Pizze(
    name: 'VERONA',
    image: 'assets/images/nettuno.png',
    prices: [13.00,	15.00],
    sizes: ['26cm','31cm'],
    description: 'Crème fraîche, mozzarella FDL, oignons rouges, guanciale croquant, gorgonzola, parmigiano ou grana',
    isPizzaRose: false,
    addIngredients: ['Tomate', 'Basilic', 'roquette', 'parmesan'],
    addIngredientsPrices: 0.50,
  ),
  Pizze(
    name: 'NAVONA',
    image: 'assets/images/nettuno.png',
    prices: [13.00,	15.00],
    sizes: ['26cm','31cm'],
    description: 'Crème fraîche, mozzarella FDL, champignons, guanciale croquant, persillade maison',
    isPizzaRose: false,
    addIngredients: ['Tomate', 'Basilic', 'roquette', 'parmesan'],
    addIngredientsPrices: 0.50,
  ),
  Pizze(
    name: '4 FORMAGGI',
    image: 'assets/images/nettuno.png',
    prices: [14.00,	16.00],
    sizes: ['26cm','31cm'],
    description: 'Crème fraîche, mozzarella FDL, chèvre, roquefort, gorgonzola',
    isPizzaRose: false,
    addIngredients: ['Tomate', 'Basilic', 'roquette', 'parmesan'],
    addIngredientsPrices: 0.50,
  ),
  Pizze(
    name: 'PEPPINO',
    image: 'assets/images/nettuno.png',
    prices: [15.00,	17.00],
    sizes: ['26cm', '31cm'],
    description: 'Crème fraîche, mozzarella FDL, gorgonzola. Après Cuisson : spianata calabrese, jambon de Parme, parmigiano ou grana, pesto génovèse',
    isPizzaRose: false,
    addIngredients: ['Tomate', 'Basilic', 'roquette', 'parmesan'],
    addIngredientsPrices: 0.50,
  ),
  Pizze(
    name: 'SALSICCIA E FRIARIELLI',
    image: 'assets/images/nettuno.png',
    prices: [13.00,	15.00],
    sizes: ['26cm', '31cm'],
    description: 'Crème fraîche, mozzarella FDL, salsiccia , friarielli',
    isPizzaRose: false,
    addIngredients: ['Tomate', 'Basilic', 'roquette', 'parmesan'],
    addIngredientsPrices: 0.50,
  ),
  Pizze(
    name: 'MARESCIALLO',
    image: 'assets/images/nettuno.png',
    prices: [13.50,	15.50],
    sizes: ['26cm', '31cm'],
    description: 'Crème fraîche, mozzarella FDL, salsiccia, radicchio, grana',
    isPizzaRose: false,
    addIngredients: ['Tomate', 'Basilic', 'roquette', 'parmesan'],
    addIngredientsPrices: 0.50,
  ),

];
