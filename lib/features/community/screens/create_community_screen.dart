import 'package:ether_app/core/common/loader.dart';
import 'package:ether_app/features/community/controller/community_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final communityNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    communityNameController.dispose();
  }

  void createCommunity() {
    ref.read(communityControllerProvider.notifier).createCommunity(
      communityNameController.text.trim(), 
      context
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a community', style: TextStyle(fontSize: 20)),
        centerTitle: true,
      ),
      body: isLoading ? const Loader() : Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const Align(alignment: Alignment.topLeft, child: Text('Community name')),
            const SizedBox(height: 10,),
            TextField(
              controller: communityNameController,
              decoration: const InputDecoration(
                hintText: 'r/community_name',
                filled: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(18), 
              ),
              maxLength: 21,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => createCommunity(), 
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55)
              ),
              child: const Text("Create community", style: TextStyle(fontSize: 16)),
            )
          ],
        ),
      ),
    );
  }
}