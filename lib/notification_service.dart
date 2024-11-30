import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;

class NotificationService {


  static Future<String> getAccessToken() async {
    const serviceAccountJson =
      {
        "type": "service_account",
        "project_id": "servicesapp2024",
        "private_key_id": "f64c41224602b58661bad7f1df88a48b5e22a5f1",
        "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDl2TwqfQpzzZfa\ncQTzj9fF3SVe0qekARytrcFmPLaxJQzzjIfwGR/Rrlr3+QRNljfuObTI5EO8BwoP\n6jsup5+3dfkmzBsCA1xTVq/L2eM5O8pAWnjSf7KKbv4mFE+ZmJGycJ1l5Uo6+7Of\ntcYT/vtKFp3GVzVyuDNPHWJ/E8xbn8kK6U3zmIAwQxzJGqMQahtA2uyTy8NuqNc1\nMstEB8GFvvlPW9qij97rC6lwCzdZwufyKG9XHGUoHITDaZO7a5Uj5wOg14ZTI15E\nWi6HseExxCeKk3rCOMZ3FDw0ap7PI3kTeR+BQSR14HzxsFimSnZeKrsPeirIYpfY\nWCnB+zzjAgMBAAECggEARmMLk0FegY8MuTbSGtpKbAvohUzCTK2QgDlNGAdwtPfR\nKwY2nNa80UPxFK4b3LyrXRcr3zdT7NFFChGjVQq9FPwaNADeJnQsAlNyG12awWyn\nZ6StCl1TqiQKTVP7+l/oAjqNYOZiIITzAW4zfe0gPBSH9XTAZ+Szxb8MajkAZHAK\nGZZCXTOWg1mMw7e9V/y9k1+WKrgNfTqLd1epEhm61fKkR22ofQozhtIX5wjAJs2S\nMmiZV8+2aT6aIPWmEg8/zTODb8418ARwKNunXVG9kXucmkg0TzfurFw6Eiub7Kt0\nUty34UPraFyjpHwshEsuKKbAsik8rKUtG7N+tjnKzQKBgQDzi6zS5g1pnBVY8FpI\nRRSNio90oY/VQpdegqzlxF2aKjknUlYVPZpN5MgPOCF4X529K9jBNKjK3Xggisra\nHM4Uhoj/eILb1raXTGICTOrTmPUYqEwyuwwhRgF9euDL7DPWG/Azf1tb5Y/yUsBY\neBDD3DLi+j6kCruotERCnCYBHQKBgQDxmj+JSeqhwBolNROvy5Gwe4vlnZjvii+A\nkazxVScNPo+vE0AG/OcEjwdkjbzX+kHUPy4kcC8W0cNJj594jNyUuyXRwXx5K3DT\nLApcCcgbXSKu6Vw83ifLClkoP1SRT/d839wa3ZdT1T1C3/5ogNXB15d7uF9ALY2a\nweB6wo/V/wKBgQDTWFpZihoJk9FSpQEzxf7X9W4YIDvZLTh+Y5f2rDkuF4YRgXoC\nZLsK7YZO7r7c3tzb1Lj8sN3pbddZJhhyvpx3Y2hvifzFGcbJ9Rb4OBdwGERZaXL2\ncytLlJymb4O0cv1oyEXh6ps1XDlWaElSfJ7P2L6wCcliQY4oEIdL5oV0YQKBgQC7\nSCiMUcIR1Inv4a77DMBIn9yYB4xv0xxze3kmMi3tdFuJCVEOmaiyvfSrG7wRZ6rz\nzm4ETPoTpFLPiQfDON4cZN4yNNw6SVRSPcdiBSsbGx0xnS+k90i9ea4XJtB1PBnK\nsPU71h3iHGA6oMvjUktg0bBZdVhQtX8ZQcSzJHK/HQKBgQC5wNVWqZyZ2bSApJXC\nTtJ0ucimpK8OjaG/ybkzzGpncR4WcSYZkfTj0sek9sftxzYVJ/hFCQ7mwxN3dO8e\nGRLyre17Gl+xWv56AI6evdFI6O427xLixt1mKWWMnKp93m4N3ZzKlvtMiY00ud6K\nLReK1EUM5ILGpcqW5RDq9GAUwg==\n-----END PRIVATE KEY-----\n",
        "client_email": "serviceappfcm@servicesapp2024.iam.gserviceaccount.com",
        "client_id": "115763657468661021643",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/serviceappfcm%40servicesapp2024.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com"
    };
    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];
    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);
    client.close();
    return credentials.accessToken.data;
  }

  static Future<void> sendNotification(
      String deviceToken, String title, String body)

  async {
    print("Device tokeeeen====$deviceToken");
    final String accessToken = await getAccessToken();

    String endpointFCM =
        'https://fcm.googleapis.com/v1/projects/servicesapp2024/messages:send';

    final Map<String, dynamic> message = {
      "message": {
        "token":
        deviceToken,
        "notification": {"title": title, "body": body},
        "data": {
          "route": "serviceScreen",
        }
      }
    };

    final http.Response response = await http.post(
      Uri.parse(endpointFCM),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(message),
    );
    if (response.statusCode == 200) {
      print('Notification sent successfully');
      Fluttertoast.showToast(
        msg: "تم إرسال الإشعار بنجاح",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      print("Failed to send notification: ${response.statusCode}");
      print('Failed to send notification');
      Fluttertoast.showToast(
        msg: "فشل في إرسال الإشعار",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  static Future<void> sendNotificationToAll(String title, String body) async {
    final String accessToken = await getAccessToken();
    String endpointFCM =
        'https://fcm.googleapis.com/v1/projects/servicesapp2024/messages:send';
    final Map<String, dynamic> message = {
      "message": {
        "topic": "all", // Use a topic to send to all subscribers
        "notification": {"title": title, "body": body},
        "data": {
          "route": "serviceScreen",
        }
      }
    };

    final http.Response response = await http.post(
      Uri.parse(endpointFCM),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print('Notification sent to all successfully');
      Fluttertoast.showToast(
        msg: "تم إرسال الإشعار إلى الجميع بنجاح",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      print('Failed to send notification to all');
      Fluttertoast.showToast(
        msg: "فشل في إرسال الإشعار إلى الجميع",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
