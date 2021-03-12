package com.teambB.koting.controller;

import com.teambB.koting.domain.MemberTest;
import java.util.Random;
import org.json.simple.JSONObject;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import java.util.HashMap;
import net.nurigo.java_sdk.api.Message;
import net.nurigo.java_sdk.exceptions.CoolsmsException;

@RestController
public class testController {

  private HashMap<String, String> dic = new HashMap<String, String>();

  @PostMapping("/auth")
  public void sendCode(@RequestBody JSONObject object) {
    String phoneNumber = object.get("phoneNumber").toString();
    String api_key = "NCSRF0PYIQASDVPU";
    String api_secret = "CR2RF1F8AWBNK406P1RD51VGBWK1881M";
    Message coolsms = new Message(api_key, api_secret);
    String code = makeRandom();
    String message = "[코팅] 인증번호[" + code + "]를 입력해주세요.";

    dic.put(phoneNumber, code);

    HashMap<String, String> params = new HashMap<String, String>();
    params.put("to", phoneNumber);
    params.put("from", "01057952740");
    params.put("type", "SMS");
    params.put("text", message);
    params.put("app_version", "test app 1.2");
    try {
      JSONObject obj = (JSONObject) coolsms.send(params);
      System.out.println(obj.toString());
    } catch (CoolsmsException e) {
      System.out.println(e.getMessage());
      System.out.println(e.getCode());
    }
  }

  @PostMapping("/auth/number")
  public boolean checkCode(@RequestBody JSONObject object) {
    String phoneNumber = object.get("phoneNumber").toString();
    String code = object.get("code").toString();

    if (dic.get(phoneNumber).equals(code)) {  // 인증번호 일치
      // 2가지 경우
      // 1. 가입 된 경우   -> 필요한 정보들 전체 리턴
      // 2. 미 가입된 경우  -> 회원가입 창으로 보내게끔 리턴
      dic.remove(phoneNumber);
      return true;
    }
    dic.remove(phoneNumber);                  // 인증번호 불 일치
    return false;
  }

  @PostMapping("/")
  public Object testMapping(@RequestBody Object params) {
    return params;
  }

  @GetMapping("/")
  public MemberTest memberGetTest() {
    return new MemberTest(0L, "Jongho Han", "is GetMan");
  }

  public String makeRandom() {
    Random rand = new Random();
    String numStr = "";
    for (int i = 0; i < 4; i++) {
      String ran = Integer.toString(rand.nextInt(10));
      numStr += ran;
    }
    System.out.println(numStr);
    return numStr;
  }
}

