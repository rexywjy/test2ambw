import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:test2ambw/customer/index.dart';
import 'package:test2ambw/customer/profile.dart';
import 'package:test2ambw/seller/index.dart';

final supabase = Supabase.instance.client;

class SellerRegister extends StatefulWidget {
  final int storestatus;
  final int userid;
  const SellerRegister({
    super.key,
    required this.storestatus,
    required this.userid,
  });
  // const SellerRegister({Key? key}) : super(key: key);
  @override
  _SellerRegisterState createState() => _SellerRegisterState();
}

class _SellerRegisterState extends State<SellerRegister> 
  with SingleTickerProviderStateMixin
{
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _storeNameController = TextEditingController();
  final _phoneController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _animationScale;
  late Animation<double> _animationFade;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animationScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.bounceOut,
      ),
    );

    _animationFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.repeat(reverse: true);
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final email = FirebaseAuth.instance.currentUser!.email.toString();
      final userr = await supabase
          .from('mcustomer')
          .select()
          .eq('Email', email)
          // .execute()
          ;  // execute the query to get the response

      // if (userr.error != null || userr.data == null || userr.data.isEmpty) {
      //   // Handle error or no user found
      //   return;
      // }

      final userid = userr[0]['ID'];
      debugPrint("USER ID : "+userid.toString());

      try{
        final response = await supabase.from('mseller').insert({
          'CustID': userid,
          'Name': _nameController.text,
          'Domain': _storeNameController.text,
          'PhoneNumber': _phoneController.text,
          // 'RekeningNumber': _rekeningController.text,
          'RekeningNumber': '1234567890',
          'Status': 0,
          'IsDel': 0,
        })
        // .execute()
        ;
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeCustomer(initialPageIndex: 2,)),
        );
      } catch (e) {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create seller account.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _storeNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if(widget.storestatus == -1){
      return Scaffold(
        appBar: AppBar(
          title: Text('Store Register'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Store Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your store name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _storeNameController,
                  decoration: InputDecoration(labelText: 'Store Domain/Username'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your store domain name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                // TextFormField(
                //   controller: _rekeningNumberController,
                //   decoration: InputDecoration(labelText: 'Rekening Number'),
                //   // keyboardType: TextInputType.phone,
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please enter your Rekening Number';
                //     }
                //     return null;
                //   },
                // ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Store Register'),

        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // AnimatedIcon(
                //   icon: AnimatedIcons.menu_close,
                //   progress: _animationController,
                // ),
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return ScaleTransition(
                      scale: _animationScale,
                      child: FadeTransition(
                        opacity: _animationFade,
                        child: const Icon(
                          Icons.airplane_ticket_rounded,
                          size: 100.0,
                          color: Colors.blue,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20.0,),
                const Expanded(
                  child: Text(
                    'You have already registered a store. Please wait for the admin to approve your store.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                            ),
                ),
              ],
            ),
        ),
      ));
    }
  }
}
