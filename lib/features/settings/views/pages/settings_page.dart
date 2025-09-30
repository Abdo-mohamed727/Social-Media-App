import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/utils/app_routs.dart';
import 'package:social_media_app/core/utils/colors.dart';
import 'package:social_media_app/features/settings/cubit/settings_cubit/settings_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final settingsCubit = context.read<SettingsCubit>();
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: size.height * .12,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'search',
              ),
            ),
            SizedBox(height: 32),
            Divider(),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit Profile'),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              leading: Icon(Icons.light_mode),
              title: Text('Theme Mode'),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              leading: Icon(Icons.translate),
              title: Text('Language'),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('About us '),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              leading: Icon(Icons.network_cell),
              title: Text('Network'),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              leading: Icon(Icons.group),
              title: Text('group'),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('other settings'),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              leading: Icon(Icons.file_copy),
              title: Text('photos/vedios'),
              trailing: Icon(Icons.chevron_right),
            ),
            Divider(),
            SizedBox(height: size.height * .01),
            BlocConsumer<SettingsCubit, SettingsState>(
              bloc: settingsCubit,
              listenWhen: (prev, curr) =>
                  curr is LogOutLooded || curr is LogoutError,
              listener: (context, state) {
                if (state is LogOutLooded) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRouts.authroute,
                    (route) => false,
                  );
                } else if (state is LogoutError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Sign out failed: ${state.message}'),
                    ),
                  );
                }
              },
              buildWhen: (previous, current) =>
                  current is LogOutLooded ||
                  current is LogOutLooding ||
                  current is LogoutError,

              builder: (context, state) {
                if (state is LogOutLooding) {
                  return Center(child: CircularProgressIndicator.adaptive());
                }
                if (state is LogOutLooded) {
                  return InkWell(
                    onTap: null,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout_outlined,
                            color: AppColors.babyBlue,
                          ),
                          SizedBox(width: 16),
                          Text(
                            'Log Out',
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  color: AppColors.babyBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return InkWell(
                  onTap: () async {
                    await settingsCubit.logout();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      children: [
                        Icon(Icons.logout_outlined, color: AppColors.babyBlue),
                        SizedBox(width: 16),
                        Text(
                          'Log Out',
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                color: AppColors.babyBlue,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
