import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tracenet/models/message.dart';
import 'package:tracenet/providers/auth_provider.dart';
import 'package:tracenet/providers/dashboard_provider.dart';
import 'package:tracenet/providers/message_provider.dart';
import 'package:tracenet/screens/dashboard/dashboard_screen.dart';
import 'package:tracenet/services/message_service.dart';

class _TestMessageService extends MessageService {
  @override
  String? get currentUserId => 'test-user';

  @override
  Future<List<Message>> getMessages() async => const [];

  @override
  Stream<List<Message>> watchMessages() => const Stream.empty();
}

void main() {
  testWidgets('Dashboard shows emergency status sections', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<AuthProvider?>.value(value: null),
          ChangeNotifierProvider<DashboardProvider>(
            create: (_) => DashboardProvider(),
          ),
          ChangeNotifierProvider<MessageProvider>(
            create: (_) => MessageProvider(messageService: _TestMessageService()),
          ),
        ],
        child: const MaterialApp(
          home: DashboardScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('TraceNet'), findsOneWidget);
    expect(find.text('Internet'), findsOneWidget);
    expect(find.text('Battery'), findsOneWidget);
    expect(find.text('SOS'), findsOneWidget);
    expect(find.text('Messages'), findsOneWidget);
    expect(find.text('Community Map'), findsOneWidget);
    expect(find.text('Nearby Users'), findsOneWidget);
  });
}
