package com.teambB.koting.firebase;

import java.io.IOException;

public class FirebaseService {

  private static FirebaseCloudMessageService firebaseCloudMessageService = new FirebaseCloudMessageService();

  public static void sendApply(String targetToken) throws IOException {
    firebaseCloudMessageService.sendMessageTo(targetToken, "⭐️ 신청이 들어왔어요 ⭐️", "누군가로부터 신청이 들어왔습니다 !");
  }

  public static void sendSuccess(String targetToken) throws IOException {
    firebaseCloudMessageService.sendMessageTo(targetToken, "매칭이 성사되었어요 😍", "채팅 탭에서 대화를 나눠보세요 !");
  }

  public static void sendReject(String targetToken) throws IOException {
    firebaseCloudMessageService.sendMessageTo(targetToken, "상대방이 신청을 거절했어요 😭", "인연이 아니었나봐요");
  }
}
