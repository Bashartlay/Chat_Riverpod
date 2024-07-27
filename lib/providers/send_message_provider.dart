import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_provider.dart';

final sendMessageProvider = FutureProvider.family<void, String>((ref, message) async {
  final supabase = ref.watch(supabaseProvider);
  await supabase.from('Chat').insert({"message": message, "is_me": false});
});
