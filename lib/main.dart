import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/cubit/cubit/post_cubit.dart';
import 'package:social_media_app/core/utils/app_constants.dart';
import 'package:social_media_app/core/utils/app_router.dart';
import 'package:social_media_app/core/utils/app_routs.dart';
import 'package:social_media_app/core/utils/app_theme.dart';
import 'package:social_media_app/features/auth/cubit/cubit/auth_cubit.dart'
    as auth;
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: AppConstants.subabaseUrl,
    anonKey: AppConstants.subabaseAnonKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => auth.AuthCubit()..checkUserAuth()),
        BlocProvider(create: (context) => PostCubit()),
      ],

      child: Builder(
        builder: (context) {
          return BlocBuilder<auth.AuthCubit, auth.AuthState>(
            bloc: BlocProvider.of<auth.AuthCubit>(context),
            buildWhen: (prev, curr) => curr is auth.AuthSuccess,
            builder: (context, state) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: AppConstants.appname,
                theme: AppTheme.lighttheme,
                onGenerateRoute: AppRouter.OngenerateRoute,
                initialRoute: state is auth.AuthSuccess
                    ? AppRouts.homeroute
                    : AppRouts.authroute,
              );
            },
          );
        },
      ),
    );
  }
}
