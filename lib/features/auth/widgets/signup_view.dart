import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/widgets/social_media_button.dart';

import '../../../core/utils/app_assets.dart';
import '../../../core/utils/app_routs.dart';
import '../../../core/utils/colors.dart';
import '../../../core/widgets/main_button.dart';
import '../cubit/cubit/auth_cubit.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _emailcontorller = TextEditingController();
  final TextEditingController _namecontorller = TextEditingController();
  final TextEditingController _passwordcontorller = TextEditingController();
  bool _isObscyre = true;
  @override
  Widget build(BuildContext context) {
    final authcubit = BlocProvider.of<AuthCubit>(context);
    return Form(
      key: _formkey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextFormField(
                controller: _namecontorller,
                decoration: InputDecoration(
                  labelText: 'User Name',
                  hintText: 'Enter Your Name',
                ),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _emailcontorller,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter Your Email',
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _passwordcontorller,
              obscureText: _isObscyre,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter Your Password',
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isObscyre = !_isObscyre;
                    });
                  },
                  icon: Icon(
                    _isObscyre ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please Enter your password';
                }
                return null;
              },
            ),
            SizedBox(height: 36),
            BlocConsumer<AuthCubit, AuthState>(
              bloc: authcubit,
              listenWhen: (prev, curr) =>
                  curr is AuthSuccess || curr is AuthFailure,
              listener: (context, state) {
                if (state is AuthSuccess) {
                  Navigator.of(context).pushNamed(AppRouts.homeroute);
                } else if (state is AuthFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return MainButton(
                  ontap: () async {
                    if (_formkey.currentState!.validate()) {
                      await authcubit.signUpWithEmail(
                        email: _emailcontorller.text,
                        password: _passwordcontorller.text,
                        name: _namecontorller.text,
                      );
                    }
                  },
                  child: Text(
                    'Sign Up',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium!.copyWith(color: AppColors.white),
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {},
                child: Text('Forget Password!'),
              ),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Divider(color: AppColors.mainindecator, thickness: 2),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Or Sign Up With',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Expanded(
                  child: Divider(color: AppColors.mainindecator, thickness: 2),
                ),
              ],
            ),
            SizedBox(height: 24),
            Column(
              children: [
                SocialMediaButton(
                  imgurl: AppAssets.googleIocn,
                  label: 'Google',
                ),
                SizedBox(height: 16),

                SocialMediaButton(
                  imgurl: AppAssets.microSoftIocn,
                  label: 'MicroSoft',
                ),
                SizedBox(height: 16),
                SocialMediaButton(
                  imgurl: AppAssets.facebook,
                  label: 'FaceBook',
                ),
                SizedBox(height: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
