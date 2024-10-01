import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, String>> projects = [
    {
      'title': 'comPower',
      'description': 'open source personal diary app ios & android',
      'image': 'assets/images/kawaii_earth.png',
    },
    {
      'title': 'comCoffee Tunis',
      'description': 'a community-managed coffee store',
      'image': 'assets/images/image.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(color: const Color(0xFFFFF3D0)),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'my Projects',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Text(
                    'explore',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: Color(0xFFD9D9D9), thickness: 2),
            SizedBox(height: screenHeight * 0.02),
            Expanded(
              child: ListView.builder(
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      color: Colors.white,
                      child: ListTile(
                        leading: Image.asset(
                          projects[index]['image']!,
                          width: 50,
                          height: 50,
                        ),
                        title: Text(
                          projects[index]['title']!,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Kumbh Sans',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: Text(
                          projects[index]['description']!,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Kumbh Sans',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
                        onTap: () {
                          // Handle project click
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
