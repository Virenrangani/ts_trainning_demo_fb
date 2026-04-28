import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ts_training_demo_fb/pages/dashboard/cubit/food_cubit.dart';
import 'package:ts_training_demo_fb/pages/dashboard/cubit/food_model.dart';
import '../../signup/components/text_form_field.dart';

class AddFood extends StatefulWidget {
  final FoodModel? foodData;

  const AddFood({super.key, this.foodData});

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  final formKey=GlobalKey<FormState>();

  final TextEditingController imageController=TextEditingController();
  final TextEditingController nameController=TextEditingController();
  final TextEditingController priceController=TextEditingController();

  @override
  void initState(){
    super.initState();
    if(widget.foodData!=null){
      imageController.text=widget.foodData?.image??" ";
      nameController.text=widget.foodData?.name??" ";
      priceController.text=widget.foodData?.price.toString()??" ";
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Form(
          key:formKey ,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomFormField(
                  labelText: "Image",
                  hintText: "Add image",
                  prefixIcon:Icons.image_outlined,
                  validator: (val){
                    if (val!.isEmpty){
                      return "Image is required";
                    }
                    return null;
                  },
                  controller:imageController,
                ),
                SizedBox(height: 10,),
                CustomFormField(
                  labelText: "Name",
                  hintText: "Add name",
                  prefixIcon:Icons.drive_file_rename_outline_outlined,
                  validator: (val){
                    if (val!.isEmpty){
                      return "name is required";
                    }
                    return null;
                  },
                  controller:nameController,
                ),
                SizedBox(height: 10,),
                CustomFormField(
                  labelText: "price",
                  hintText: "Add price",
                  prefixIcon:Icons.money,
                  validator: (val){
                    if (val!.isEmpty){
                      return "price is required";
                    }
                    return null;
                  },
                  controller:priceController,
                ),
                SizedBox(height: 15,),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final cubit = context.read<FoodCubit>();
                      if(widget.foodData==null){
                        await cubit.addFood(
                          image: imageController.text,
                          name: nameController.text,
                          price: double.parse(priceController.text),
                        );
                        await FirebaseAnalytics.instance.logEvent(name: "food_created");
                      }else{
                        await cubit.updateFood(
                            id: widget.foodData!.id,
                            image: imageController.text,
                            name: nameController.text,
                            price: double.parse(priceController.text),
                        );
                        await FirebaseAnalytics.instance.logEvent(name:"food_update");

                      }

                      Navigator.pop(context);

                    }
                  },
                  child: Text(widget.foodData==null?"Submit":"Update"),
                )
              ],
            ),
          ),
        ),
      );
  }
}
