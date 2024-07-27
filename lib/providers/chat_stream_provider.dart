import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_provider.dart';

final chatStreamProvider = StreamProvider.autoDispose((ref) {
  final supabase = ref.watch(supabaseProvider);
  // ignore: deprecated_member_use
  return supabase.from('Chat').stream(primaryKey: ['id']).execute();
});
