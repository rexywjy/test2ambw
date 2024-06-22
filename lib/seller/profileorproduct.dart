import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:test2ambw/seller/index.dart';

class ProfileOrProduct extends StatefulWidget {
  // final bool goToProfile;
  final String emailBuyer;
  const ProfileOrProduct({
    super.key,
    // required this.goToProfile
    required this.emailBuyer
  });

  @override
  State<ProfileOrProduct> createState() => _ProfileOrProductState();
}

final supabase = Supabase.instance.client;
class _ProfileOrProductState extends State<ProfileOrProduct> {
  bool isFirstLoad = true;

  Future<void> checkHaveSellerAccount() async {
    // debugPrint("FETCHING NAME");
    // debugPrint("USERR : "+FirebaseAuth.instance.currentUser!.email.toString());
    final response = await supabase
        .from('mseller')
        .select()
        .eq('Email', widget.emailBuyer)
        // .execute()
        ;
    // setState(() {
    //   if(response.length <= 0){
    //     debugPrint("SELLER ACC : NO SELLER ACCOUNT");
    //     // return HomeSeller();
    //   }else{
    //     debugPrint("SELLER ACC : SELLER ACCOUNT EXISTS");
    //     // return HomeSeller();
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    if(isFirstLoad){
      checkHaveSellerAccount();
      isFirstLoad = false;
      return CircularProgressIndicator();
    } else {
      if(widget.emailBuyer == null || widget.emailBuyer == ""){
        // return MyProducts();
        return HomeSeller();
      }else{
        return HomeSeller();
      }
    }
  }
}