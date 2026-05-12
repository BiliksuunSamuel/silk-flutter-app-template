import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:silk/core/router/route_paths.dart';
import 'package:silk/core/router/transitions/fade_page.dart';
import 'package:silk/core/router/transitions/shared_axis_page.dart';
import 'package:silk/features/auth/presentation/providers/session_provider.dart';
import 'package:silk/features/auth/presentation/screens/login_screen.dart';
import 'package:silk/features/auth/presentation/screens/otp_screen.dart';
import 'package:silk/features/home/presentation/screens/home_stub_screen.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(AppRouterRef ref) {
  final router = GoRouter(
    initialLocation: RoutePaths.login,
    redirect: (context, state) {
      final sessionState = ref.read(sessionNotifierProvider);
      final isAuthenticated = sessionState.valueOrNull != null;
      final path = state.matchedLocation;
      final isOnAuth = path == RoutePaths.login || path == RoutePaths.otp;

      if (!isAuthenticated && !isOnAuth) return RoutePaths.login;
      if (isAuthenticated && isOnAuth) return RoutePaths.home;
      return null;
    },
    routes: [
      // push — login entry
      GoRoute(
        path: RoutePaths.login,
        pageBuilder: (context, state) => SharedAxisPage(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),

      // push — OTP verification
      GoRoute(
        path: RoutePaths.otp,
        pageBuilder: (context, state) => SharedAxisPage(
          key: state.pageKey,
          child: const OtpScreen(),
        ),
      ),

      // replace — home shell (fade-through on auth success)
      GoRoute(
        path: RoutePaths.home,
        pageBuilder: (context, state) => FadePage(
          key: state.pageKey,
          child: const HomeStubScreen(),
        ),
      ),
    ],
  );

  ref
    ..listen(sessionNotifierProvider, (_, __) => router.refresh())
    ..onDispose(router.dispose);

  return router;
}
