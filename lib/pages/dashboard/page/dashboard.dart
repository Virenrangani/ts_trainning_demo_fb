import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ts_training_demo_fb/pages/dashboard/cubit/food_model.dart';
import '../cubit/food_cubit.dart';
import '../cubit/food_state.dart';
import 'add_food.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FoodCubit()..fetchFoods(),
      child: Builder(
        builder:(context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Dashboard"),
              centerTitle: true,
              backgroundColor: Colors.deepPurpleAccent,
            ),
            body: BlocConsumer<FoodCubit, FoodState>(
              listener: (context, state) {
                if (state is FoodFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is FoodLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is FoodLoaded) {
                  return _buildList(context, state.foods);
                }
                if (state is FoodFailure &&
                    state.previousFoods != null) {
                  return _buildList(context, state.previousFoods!);
                }

                if (state is FoodFailure) {
                  return const Center(
                    child: Text("Something went wrong"),
                  );
                }

                return const SizedBox();
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) =>
                      BlocProvider.value(
                        value: context.read<FoodCubit>(),
                        child: const AddFood(),
                      ),
                );
              },
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }

  Widget _buildList(BuildContext context, List<FoodModel> foods) {
    if (foods.isEmpty) {
      return const Center(
        child: Text("No food added"),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: foods.length,
            itemBuilder: (context, index) {
              final food = foods[index];
              return Card(
                child: ListTile(
                  leading: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async{
                      await context.read<FoodCubit>().deleteFood(food.id);

                      await FirebaseAnalytics.instance.logEvent(
                          name: "food_delete",
                          parameters: {
                        "food_name":food.name
                      });
                      print("Delete food");

                    },
                  ),
                  title: Text(food.name),
                  subtitle: Text("₹ ${food.price}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => BlocProvider.value(
                          value: context.read<FoodCubit>(),
                          child: AddFood(foodData: food),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
        TextButton(onPressed: (){
          var firebaseInstance = FirebaseCrashlytics.instance;
          firebaseInstance.setCustomKey("userId", "Viren");
          firebaseInstance.log("Crash automatically");
          firebaseInstance.crash();
        }, child: Text("Crash")
        )
      ],
    );
  }
}