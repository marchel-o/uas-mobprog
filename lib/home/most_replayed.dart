import 'package:flutter/material.dart';

class HomeMostReplayed extends StatelessWidget{
  final List mostReplayed;

  const HomeMostReplayed({
    super.key, 
    required this.mostReplayed,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: mostReplayed.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final song = mostReplayed[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    color: const Color(0xFF282828),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.music_note,
                    size: 22,
                    color: Color(0xFF1DB954),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(song['title']),
                      Text(
                        song['artist'], 
                        style: TextStyle(
                          color: Colors.grey
                        ),
                      ),
                    ],
                  ),
                ),

                IconButton(
                  icon: Icon(!song['saved'] ? Icons.add_circle_outline : Icons.check_circle), 
                  iconSize: 18, 
                  color: song['saved'] ? Colors.green : Colors.white,
                  style: IconButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.all(4),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () { },
                ),

                const SizedBox(width: 16),

                IconButton(
                  icon: const Icon(Icons.more_vert), 
                  iconSize: 18, 
                  style: IconButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.all(4),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () { },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}