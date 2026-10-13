import 'package:bootcamp_finder/model/bootcamp.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/bootcamp_cubit.dart';
import 'bootcamp_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> categories = const ['All', 'Development', 'AI', 'Design'];
  String selected = 'All';
  bool searching = false;
  String query = '';
  final searchCtrl = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  //   loadBootcamps();
  // }
  // // (جديد) تجيب المعسكرات من Supabase وتحطها بالقائمة
  // Future<void> loadBootcamps() async {
  //   setState(() {
  //     isLoading = true;
  //     hasError = false;
  //   });
  //   try {
  //     final data = await BootcampService.getBootcamps();
  //     if (!mounted) return;
  //     setState(() {
  //       bootcamps = data;
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     if (!mounted) return;
  //     setState(() {
  //       isLoading = false;
  //       hasError = true;
  //     });
  //   }
  // }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  List<Bootcamp> _filter(List<Bootcamp> all) => all.where((b) {
    final bCat = b.category.trim().toLowerCase();
    final sCat = selected.trim().toLowerCase();
    final matchCat = selected == 'All' || bCat == sCat;
    final q = query.trim().toLowerCase();
    final matchQuery =
        q.isEmpty ||
        b.name.toLowerCase().contains(q) ||
        b.desc.toLowerCase().contains(q);
    return matchCat && matchQuery;
  }).toList(); //دالة جاهزة تحول النتيجة لقائمة عادية

  void _toggleSearch() {
    setState(() {
      searching = !searching;
      if (!searching) {
        query = '';
        searchCtrl.clear();
        FocusScope.of(context).unfocus();
      }
    });
  }

  OutlineInputBorder _border(Color c) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(color: c),
  );

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off_rounded, color: Colors.white38, size: 48),
          const SizedBox(height: 12),
          const Text(
            'Something went wrong',
            style: TextStyle(color: Colors.white54, fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            // (جديد) نقول للـ Cubit يجيب المعسكرات من جديد
            onPressed: () => context.read<BootcampCubit>().loadBootcamps(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        toolbarHeight: 90,
        titleSpacing: 24,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Explore Bootcamps',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Swipe to discover more',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.white54,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: _toggleSearch,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: searching ? Colors.white : const Color(0xFF1C1B22),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Icon(
                  searching ? Icons.close_rounded : Icons.search_rounded,
                  color: searching ? Colors.black : Colors.white70,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (searching)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 14),
              child: TextField(
                controller: searchCtrl,
                autofocus: true,
                onChanged: (v) => setState(() => query = v),
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: 'Search bootcamps...',
                  hintStyle: const TextStyle(color: Colors.white38),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Colors.white54,
                  ),
                  suffixIcon: query.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(
                            Icons.clear_rounded,
                            color: Colors.white54,
                          ),
                          onPressed: () => setState(() {
                            query = '';
                            searchCtrl.clear();
                          }),
                        ),
                  filled: true,
                  fillColor: const Color(0xFF1C1B22),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: _border(Colors.white.withValues(alpha: 0.08)),
                  enabledBorder: _border(Colors.white.withValues(alpha: 0.08)),
                  focusedBorder: _border(Colors.white38),
                ),
              ),
            ),
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, i) {
                final c = categories[i];
                final active = c == selected;
                return GestureDetector(
                  onTap: () => setState(() => selected = c),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: active ? Colors.white : const Color(0xFF1C1B22),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withValues(
                          alpha: active ? 0 : 0.08,
                        ),
                      ),
                    ),
                    child: Text(
                      c,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: active ? Colors.black : Colors.white70,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
          
            child: BlocBuilder<BootcampCubit, BootcampState>(
              builder: (context, state) {
             
                if (state is BootcampLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                
                if (state is BootcampError) {
                  return _buildError();
                }

               
                if (state is BootcampSuccess) {
                  final items = _filter(state.bootcamps);

                  if (items.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            color: Colors.white38,
                            size: 48,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'No bootcamps found',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Swiper(
                    key: ValueKey('$selected$query${items.length}'),
                    itemCount: items.length,
                    viewportFraction: 0.82,
                    scale: 0.9,
                    loop: false,
                    pagination: items.length > 1
                        ? const SwiperPagination(
                            margin: EdgeInsets.only(bottom: 4),
                            builder: DotSwiperPaginationBuilder(
                              color: Colors.white24,
                              activeColor: Colors.white,
                              size: 7,
                              activeSize: 9,
                            ),
                          )
                        : null,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 36),
                      child: _BootcampCard(camp: items[index]),
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _BootcampCard extends StatelessWidget {
  final Bootcamp camp; 
  const _BootcampCard({required this.camp});

  @override
  Widget build(BuildContext context) {
    final Color color =
        camp.color; 
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withValues(alpha: 0.35), const Color(0xFF1C1B22)],
          stops: const [0, 0.6],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.25),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(camp.icon, color: Colors.white, size: 32),
              ),
              const Spacer(),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.bookmark_border_rounded,
                  color: Colors.white70,
                  size: 20,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            camp.category.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            camp.name,
            style: const TextStyle(
              fontSize: 26,
              height: 1.2,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            camp.desc,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
              color: Colors.white60,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _chip(Icons.schedule_rounded, '${camp.weeks} weeks'),
              const SizedBox(width: 8),
              _chip(Icons.signal_cellular_alt_rounded, camp.level),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BootcampDetailsPage(camp: camp),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View details',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.07),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: Colors.white70),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 13, color: Colors.white70)),
      ],
    ),
  );
}
