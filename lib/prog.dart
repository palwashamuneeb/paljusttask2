import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math'; // For generating random numbers

void main() {
  runApp(APIApp());
}

class APIApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PostScreen(),
    );
  }
}

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  bool _isLoading = false; // State for loading spinner
  String? _postTitle; // Fetched post title
  String? _postBody; // Fetched post body
  String? _errorMessage; // Error message, if any

  // Function to fetch data from API
  Future<void> _fetchRandomPost() async {
    setState(() {
      _isLoading = true; // Start loading
      _postTitle = null;
      _postBody = null;
      _errorMessage = null;
    });

    // Generate a random post ID (1 to 100)
    int randomId = Random().nextInt(100) + 1;

    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts/$randomId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body); // Parse JSON response
        setState(() {
          _postTitle = data['title'];
          _postBody = data['body'];
        });
      } else {
        setState(() {
          _errorMessage = "Failed to fetch data: ${response.statusCode}";
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = "An error occurred: $error";
      });
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fetch Random Post"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading)
                CircularProgressIndicator() // Show loading spinner
              else if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 18),
                  textAlign: TextAlign.center,
                )
              else if (_postTitle != null && _postBody != null)
                Column(
                  children: [
                    Text(
                      _postTitle!,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      _postBody!,
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _fetchRandomPost,
                child: Text("Fetch Random Post"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
