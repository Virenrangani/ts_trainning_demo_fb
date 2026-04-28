
import 'package:ts_training_demo_fb/pages/dashboard/cubit/food_model.dart';

abstract class FoodState {}

class FoodInitial extends FoodState{}

class FoodLoading extends FoodState{}

class FoodLoaded extends FoodState{
  final List<FoodModel> foods;
  FoodLoaded(this.foods);
}

class AddFoodSuccess extends FoodState{}

class FoodFailure extends FoodState{
  final List<FoodModel>? previousFoods;
  final String message;
  FoodFailure(this.message, {this.previousFoods});
}