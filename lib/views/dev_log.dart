import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop_final/services/dev_logger.dart';

class DevLogScreen extends StatelessWidget {
  const DevLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: DevLogger.instance,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dev Log'),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_forever),
              tooltip: 'Clear log',
              onPressed: () => DevLogger.instance.clear(),
            ),
          ],
        ),
        body: Consumer<DevLogger>(
          builder: (context, logger, child) {
            final messages = logger.messages;
            if (messages.isEmpty) {
              return const Center(child: Text('No log messages'));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: messages.length,
              separatorBuilder: (_, __) => const Divider(height: 8),
              itemBuilder: (context, index) {
                final msg = messages[index];
                return SelectableText(msg);
              },
            );
          },
        ),
      ),
    );
  }
}
