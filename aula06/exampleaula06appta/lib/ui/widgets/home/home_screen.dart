import 'package:appaula06deliveryta/data/categories_data.dart';
import 'package:appaula06deliveryta/data/restaurant_data.dart';
import 'package:appaula06deliveryta/model/restaurant.dart';
import 'package:appaula06deliveryta/ui/_core/app_colors.dart';
import 'package:appaula06deliveryta/ui/widgets/home/widgets/category_widget.dart';
import 'package:appaula06deliveryta/ui/widgets/home/widgets/restaurant_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appaula06deliveryta/ui/screens/drinks_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurantData = Provider.of<RestaurantData>(context);

    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(title: const Text('App Delivery')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'assets/logo.png',
                width: 120,
                height: 120,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),

              // Boas-vindas
              const Text(
                'Boas vindas !',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Texto centralizado
              const Text(
                'Escolha por categoria',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Categorias horizontais centralizadas
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    CategoriesData.listCategories.length,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CategoryWidget(
                        category: CategoriesData.listCategories[index],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Banner menor e centralizado
              Center(
                child: Image.asset(
                  'assets/banners/banner_promo.png',
                  width: MediaQuery.of(context).size.width * 0.8, // 80% da tela
                  height: 180,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),

              // Bem avaliados
              const Text(
                'Bem avaliados',
                style: TextStyle(
                    color: AppColors.mainColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Lista de restaurantes
              Column(
                children: List.generate(
                  restaurantData.listRestaurant.length,
                  (index) {
                    final restaurant = restaurantData.listRestaurant[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: RestaurantWidget(restaurant: restaurant),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Botão Ver Bebidas
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DrinksScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Ver Bebidas",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 64),
            ],
          ),
        ),
      ),
    );
  }
}
