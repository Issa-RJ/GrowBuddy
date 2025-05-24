// lib/ui/screens/advice_page.dart

import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/disease_api.dart';
import '../../services/perenual_api_service.dart';
import '../../constants.dart';

class AdvicePage extends StatefulWidget {
  const AdvicePage({Key? key}) : super(key: key);

  @override
  State<AdvicePage> createState() => _AdvicePageState();
}

class _AdvicePageState extends State<AdvicePage> {
  late Future<DiseaseApi> _diseaseFuture;
  String _quote = '';
  final Random _random = Random();

  static const List<String> _quotes = [
    "The earth laughs in flowers.",
    "To plant a garden is to believe in tomorrow.",
    "Plants give us oxygen for the lungs and for the soul.",
    "A society grows great when old men plant trees whose shade they know they shall never sit in.",
    "He who plants a tree plants hope.",
    "Look deep into nature, and then you will understand everything better.",
    "Adopt the pace of nature: her secret is patience.",
    "The clearest way into the Universe is through a forest wilderness.",
    "Where flowers bloom so does hope.",
    "Nature does not hurry, yet everything is accomplished.",
    "Gardening adds years to your life and life to your years.",
    "Green is the prime color of the world.",
    "There are no gardening mistakes, only experiments.",
    "Life begins the day you start a garden.",
    "Every flower is a soul blossoming in nature.",
  ];

  @override
  void initState() {
    super.initState();
    _loadRandom();
  }

  void _loadRandom() {
    setState(() {
      _quote = _quotes[_random.nextInt(_quotes.length)];
      _diseaseFuture = PerenualApiService()
          .fetchDiseases()
          .then((list) => list[_random.nextInt(list.length)]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Constants.primaryColor,
        child: const Icon(Icons.refresh),
        onPressed: _loadRandom,
      ),
      body: FutureBuilder<DiseaseApi>(
        future: _diseaseFuture,
        builder: (ctx, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final d = snap.data!;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 220,
                backgroundColor: Constants.primaryColor,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(d.commonName ?? 'Plant Advice'),
                  background: d.imageUrl != null
                      ? Image.network(d.imageUrl!, fit: BoxFit.cover)
                      : Container(color: Colors.grey.shade300),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Quote
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          '“$_quote”',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 18,
                            color: Constants.blackColor.withOpacity(.8),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // What is...
                    Text(
                      'What is ${d.commonName}?',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Constants.primaryColor),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          d.description,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(height: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // How it occurs
                    if (d.solution != null && d.solution!.isNotEmpty) ...[
                      Text(
                        'How does it occur?',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: Constants.primaryColor),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            d.solution!,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(height: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Solution (italic)
                    if (d.solution != null && d.solution!.isNotEmpty) ...[
                      Text(
                        'Solution',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: Constants.primaryColor),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            d.solution!,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                                fontStyle: FontStyle.italic, height: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
