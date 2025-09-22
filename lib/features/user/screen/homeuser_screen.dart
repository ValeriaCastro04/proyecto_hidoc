import 'package:flutter/material.dart';
import 'package:proyecto_hidoc/features/user/widgets/footer_user.dart';
import 'package:proyecto_hidoc/common/shared_widgets/footer.dart';

class HomeUserScreen extends StatelessWidget {
  static const String name = 'HomeUser';
  const HomeUserScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: Footer(
        buttons: userFooterButtons(context, current: UserTab.home),
      ),
    );
  }
}
