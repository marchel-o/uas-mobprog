import 'package:flutter/material.dart';

class HomeTopBar extends StatelessWidget{
  final List categories;
  
  const HomeTopBar({
    super.key,
    required this.categories,
  });
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          child: const Text(
            'W',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
        ),
        
        const SizedBox(width: 12),

        Expanded(
          child: SizedBox(
            height: 32,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = categories[index];
                return Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF282828),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    category['title']!,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ), 
        ),
      ],
    );
  }
}