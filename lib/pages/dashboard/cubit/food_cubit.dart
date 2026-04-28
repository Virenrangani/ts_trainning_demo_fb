import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../dashboard/cubit/food_model.dart';
import '../../dashboard/cubit/food_state.dart';

class FoodCubit extends Cubit<FoodState> {
  FoodCubit() :super(FoodInitial());

  List<FoodModel> foodsList = [];

  Future<void> addFood({
    required String image,
    required String name,
    required double price
  }) async {
    try {
      await FirebaseFirestore.instance.collection("food").add(
          {
            "image": image,
            "name": name,
            "price": price,
            "userId": FirebaseAuth.instance.currentUser?.uid,
          }
      );
      emit(AddFoodSuccess());

      await fetchFoods();
    } catch (e) {
      emit(FoodFailure(e.toString()));
    }
  }

  Future<void> updateFood({
    required String id,
    required String image,
    required String name,
    required double price,
  }) async {
    try {
      await FirebaseFirestore.instance.collection("food").doc(id).update({
        "image": image,
        "name": name,
        "price": price,
      });
      await fetchFoods();
    } on FirebaseException catch (e) {
      emit(FoodFailure(e.toString(),previousFoods: foodsList));

    }
  }

  Future<void> fetchFoods() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('food')
          .get();

        foodsList = snapshot.docs.map((doc) {
        return
          FoodModel.fromMap(doc.data(), doc.id);
      }).toList();
      emit(FoodLoaded(foodsList));
    } catch (e) {
      emit(FoodFailure(e.toString()));
    }
  }

  Future<void> deleteFood(String id) async {
    try {
      await FirebaseFirestore.instance.collection("food").doc(id).delete();

      await fetchFoods();
    } on FirebaseException catch (e) {
      emit(FoodFailure(e.toString(),previousFoods: foodsList));
    }
  }
}