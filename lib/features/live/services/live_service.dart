import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:takshasila_app/constants/app_constants.dart';
import 'package:takshasila_app/constants/config.dart';
import 'package:takshasila_app/constants/utils.dart';
import 'package:takshasila_app/models/live_model.dart';

class LiveService {
  Future<LiveModel?> getLiveClass({
    // Change the return type to LiveModel?
    required BuildContext context,
  }) async {
    
    String userId = userData.userid;
    try {
      var headers = {
        'Cookie': 'etcpro_ci_session=gmrvscad9fs8eud4vs3cb12d9kgtj6ib'
      };
      var request =
          http.MultipartRequest('GET', Uri.parse('$baseUrl$liveClass'));
      request.fields.addAll({
        'userid': userId,
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseData = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = jsonDecode(responseData);
        var liveModel = LiveModel.fromJson(jsonResponse);
       // showSnackbar(context, 'Live class fetched successfully');
        return liveModel; // Return the liveModel
      } else {
        showSnackbar(context, 'Live class fetched successfully');
        print('Error: ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
}
