package com.teambB.koting.firebase;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.auth.oauth2.GoogleCredentials;
import java.util.List;
import java.io.IOException;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import org.codehaus.jackson.JsonProcessingException;
import org.springframework.core.io.ClassPathResource;

public class FirebaseCloudMessageService {

  private final String API_URL = "https://fcm.googleapis.com/v1/projects/koting-ios/messages:send";
  private final ObjectMapper objectMapper = new ObjectMapper();

  public void sendMessageTo(String targetToken, String title, String body) throws IOException {
    String message = makeMessage(targetToken, title, body);

    OkHttpClient client = new OkHttpClient();
    RequestBody requestBody = RequestBody.create(message, MediaType.get("application/json; charset=utf-8"));
    Request request = new Request.Builder()
        .url(API_URL)
        .post(requestBody)
        .addHeader("Authorization", "Bearer " + getAccessToken())
        .addHeader("Content-Type", "application/json; UTF-8")
        .build();

    Response response = client.newCall(request).execute();

    System.out.println(response.body().string());
  }

  private String makeMessage(String targetToken, String title, String body)
      throws JsonProcessingException, com.fasterxml.jackson.core.JsonProcessingException {
    FcmMessage fcmMessage = FcmMessage.builder()
        .message(FcmMessage.Message.builder()
            .token(targetToken)
            .notification(FcmMessage.Notification.builder()
            .title(title)
            .body(body)
            .image(null)
            .build()
            ).build()
        )
        .validate_only(false)
        .build();
    return objectMapper.writeValueAsString(fcmMessage);
  }

  private String getAccessToken() throws IOException {
    String firebaseConfigPath = "firebase/koting-ios-firebase-adminsdk-zbh1u-d98f39af3c.json";

    GoogleCredentials googleCredentials = GoogleCredentials
        .fromStream(new ClassPathResource(firebaseConfigPath).getInputStream())
        .createScoped(List.of("https://www.googleapis.com/auth/cloud-platform"));
    googleCredentials.refreshIfExpired();

    return googleCredentials.getAccessToken().getTokenValue();
  }

}
