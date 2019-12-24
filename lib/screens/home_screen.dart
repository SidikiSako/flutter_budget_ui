import 'package:flutter/material.dart';
import 'package:flutter_budget_ui/data/data.dart';
import 'package:flutter_budget_ui/helpers/color_helper.dart';
import 'package:flutter_budget_ui/models/category_model.dart';
import 'package:flutter_budget_ui/models/expense_model.dart';
import 'package:flutter_budget_ui/screens/category_screen.dart';
import 'package:flutter_budget_ui/widgets/bar_chart.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _buildCategory(Category category, double totalAmountSpent) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CategoryScreen(category: category),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        height: 100.0,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  category.name,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${(category.maxAmount - totalAmountSpent).toStringAsFixed(2)}€ / ${category.maxAmount.toStringAsFixed(2)}€',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            //la taille de notre 2e container sera calculer en fonction de la taille
            //du 1er container. Le problème que la taille du 1er container peut changer
            //en fonction de la taille de l'écran. Pour resoudre le problème, on wrap
            //notre Stack dans un LayoutBuilder
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                print(constraints.maxHeight);
                //constraints.maxWidth = width de notre premier container
                print(constraints.maxWidth);

                //calculons la taille de barre de depense pour une category
                final double maxBarWith = constraints.maxWidth;
                final double percent = (category.maxAmount - totalAmountSpent) /
                    category.maxAmount;
                //la taille de notre barre
                double barWidth = percent * maxBarWith;

                if (barWidth < 0) {
                  barWidth = 0;
                }
                return Stack(
                  children: <Widget>[
                    Container(
                      height: 20.0,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    //2e container pour afficher la barre de nos depenses
                    Container(
                      height: 20.0,
                      width: barWidth,
                      decoration: BoxDecoration(
                        // on crée une fonction qui determine la color d'une bar en fonction de sa taille
                        // on context pour pouvoir utiliser notre primaryColor
                        color: getColor(context, percent),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            expandedHeight: 100.0,
            forceElevated: true,
            leading: IconButton(
              icon: Icon(Icons.settings),
              iconSize: 30.0,
              onPressed: () {},
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Simple Budget',
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                iconSize: 30.0,
                onPressed: () {},
              ),
            ],
          ),

          //Notre liste d'item
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                //si index == 0, on affiche weekly Spending sinon on affiche les category
                if (index == 0) {
                  //c'est ici qu'on construit les items de notre liste
                  return Container(
                    //je met une margin sinon on ne voit pas de séparation entre les items
                    margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 2),
                          blurRadius: 6.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: BarChart(weeklySpending),
                  );
                } else {
                  // -1 parce que index est en avance sur le compteur de notre tableau categories
                  final Category category = categories[index - 1];
                  double totalAmountSpent = 0;
                  category.expenses.forEach((Expense expense) {
                    totalAmountSpent += expense.cost;
                  });
                  return _buildCategory(category, totalAmountSpent);
                }
              },
              //nb item de la list
              childCount: 1 + categories.length,
            ),
          )
        ],
      ),
    );
  }
}
