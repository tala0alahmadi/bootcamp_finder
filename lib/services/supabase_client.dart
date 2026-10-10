import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://aluhfidzxahmajtgamiy.supabase.co',
      publishableKey: 'sb_publishable_5Mu8rbRhvfWHIRnH_rclMA_A2bHAcl3',
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
