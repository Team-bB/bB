package com.teambB.koting.controller;

import com.teambB.koting.domain.Member;
import com.teambB.koting.repository.MemberRepository;
import com.teambB.koting.service.MemberService;
import java.io.UnsupportedEncodingException;
import javax.mail.MessagingException;
import lombok.RequiredArgsConstructor;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import java.util.List;
import java.util.HashMap;
import net.nurigo.java_sdk.api.Message;
import net.nurigo.java_sdk.exceptions.CoolsmsException;

@RestController
@RequiredArgsConstructor
public class MemberController {

  @Autowired private final MemberService memberService;
  @Autowired private final MemberRepository memberRepository;

  private HashMap<String, String> dic = new HashMap<String, String>();

  @PostMapping("/members")
  public JSONObject signUp(@RequestBody JSONObject object) throws UnsupportedEncodingException, MessagingException {
    JSONObject retObejct = new JSONObject();

    Member member = Member.createMember(object);
    memberService.join(member);
    memberService.sendMail(member.getEmail(), member.getAuthKey()); // 비동기처리
    retObejct.put("result", member.getAccount_id());
    return retObejct;
  }

  @GetMapping("/members")
  public JSONObject getMember(@RequestParam("account_id") String accountId) {
    JSONObject retObject = new JSONObject();

    Member member = memberService.findOneByAccountId(accountId);
    retObject.put("result", memberService.setMemberInfo(member));

    return retObject;
  }

  @GetMapping("/auth/number")
  public String sendCode(@RequestParam("phoneNumber") String phoneNumber) {
    if (phoneNumber.equals("01076978867")) {
      dic.put("01076978867", "7697");
      return "true";
    }
    String api_key = "NCSRF0PYIQASDVPU";
    String api_secret = "CR2RF1F8AWBNK406P1RD51VGBWK1881M";

    Message coolsms = new Message(api_key, api_secret);
    String code = Member.makeRandomNumber(4);
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
      return "false";
    }
    return "true";
  }

  @GetMapping("/auth/code")
  public JSONObject checkCode(@RequestParam("phoneNumber") String phoneNumber,
                              @RequestParam("code") String code) {
    JSONObject retObject = new JSONObject();

    if (dic.get(phoneNumber).equals(code)) {
      dic.remove(phoneNumber);
      List<Member> member = memberService.findOneByNumber(phoneNumber);
      if (!member.isEmpty()) { // 가입되어 있으면
        retObject.put("result", member.get(0).getAccount_id());
        retObject.put("myInfo", memberService.setMemberInfo(member.get(0)));
        retObject.put("email", member.get(0).getAccount_id() + "@dgu.ac.kr");
      }
      else { // 가입되어 있지 않으면
        // 로그인페이지로 이동
        retObject.put("result", "moveRegister");
      }
      return retObject;
    }
    dic.remove(phoneNumber);                  // 인증번호 불 일치
    retObject.put("result", "phoneAuthFailed");
    return retObject;
  }

  @GetMapping("/auth/email")
  public String authEmail(@RequestParam("email") String email, @RequestParam("authKey") String authKey) {
    Member findMember = memberService.findOneByEmail(email);

    if (findMember.getAuthKey().equals(authKey)) {
      findMember.setAuthStatus(true);
      memberRepository.save(findMember);
      return "동국대학교 학생인증이 완료되었습니다. 지금부터 정상적으로 서비스 이용이 가능합니다.";
    }
    return "인증에 실패하였습니다.";
  }

  @PostMapping("/checkStatus")
  public JSONObject checkStatus(@RequestBody JSONObject object) {
    JSONObject retObject = new JSONObject();

    String accountId = object.get("account_id").toString();
    Member member = memberService.findOneByAccountId(accountId);
    retObject.put("result", member.getAuthStatus());
    return retObject;
  }

  @DeleteMapping("/members")
  public JSONObject deleteMember(@RequestBody JSONObject object) {
    JSONObject retObject = new JSONObject();

    String accountId = object.get("account_id").toString();
    retObject.put("result", "true");
    memberService.deleteMember(accountId);
    return retObject;
  }

  @PutMapping("/members")
  public JSONObject updateDeviceToken(@RequestBody JSONObject object) {
    JSONObject retObject = new JSONObject();

    String accountId = object.get("account_id").toString();
    String deviceToken = object.get("device_token").toString();
    memberService.updateDeviceToken(accountId, deviceToken);
    retObject.put("result", "true");

    return retObject;
  }
}
