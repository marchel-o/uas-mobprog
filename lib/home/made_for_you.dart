import 'package:flutter/material.dart';

class HomeMadeForYou extends StatelessWidget{
  final List madeForYou;
  
  const HomeMadeForYou({
    super.key, 
    required this.madeForYou
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: madeForYou.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final mix = madeForYou[index];
          return SizedBox(
            width: 145,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 135,
                  width: 145,
                  decoration: BoxDecoration(
                    color: const Color(0xFF282828),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.album,
                    size: 64,
                    color: Color(0xFF1DB954),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  mix['title']!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  mix['subtitle']!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
}