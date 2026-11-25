import 'package:flutter/material.dart';

class HomeRecentPlaylist extends StatelessWidget {
  final List recentPlaylists;
  
  const HomeRecentPlaylist({
    super.key,
    required this.recentPlaylists,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recentPlaylists.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3.1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final item = recentPlaylists[index];
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF282828),
            borderRadius: BorderRadius.circular(6),
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              Container(
                width: 56,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: item['color'] as Color,
                  borderRadius: BorderRadius.circular(6),  
                ),
                child: const Icon(Icons.music_note, color: Colors.white),
              ),
              // const SizedBox(width: 6),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    item['title'] as String,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                )
                
              ),
            ],
          ),
        );
      },
    );
  }

}