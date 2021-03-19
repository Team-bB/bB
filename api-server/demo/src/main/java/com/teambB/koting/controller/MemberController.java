package com.teambB.koting.controller;

import com.teambB.koting.domain.Member;
import com.teambB.koting.repository.MemberRepository;
import com.teambB.koting.service.MemberService;
import java.io.UnsupportedEncodingException;
import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.json.simple.JSONObject;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import java.util.HashMap;
import net.nurigo.java_sdk.api.Message;
import net.nurigo.java_sdk.exceptions.CoolsmsException;

@RestController
@RequiredArgsConstructor
public class MemberController {

  @Autowired private final MemberService memberService;
  @Autowired private final MemberRepository memberRepository;
  @Autowired private JavaMailSender javaMailSender;
  @Autowired EntityManager em;
  private HashMap<String, String> dic = new HashMap<String, String>();

  @PostMapping("/auth")
  public String sendCode(@RequestBody JSONObject object) {

    String phoneNumber = object.get("phoneNumber").toString();
    String api_key = "NCSRF0PYIQASDVPU";
    String api_secret = "CR2RF1F8AWBNK406P1RD51VGBWK1881M";
    Message coolsms = new Message(api_key, api_secret);
    String code = Member.makeRandomNumber(4);
    String message = "[코팅] 인증번호[" + code + "]를 입력해주세요.";
    dic.put(phoneNumber, code);

    System.out.println(code);

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

  @PostMapping("/auth/number")
  public JSONObject checkCode(@RequestBody JSONObject object) {

    JSONObject retObject = new JSONObject();
    String phoneNumber = object.get("phoneNumber").toString();
    String code = object.get("code").toString();
    if (dic.get(phoneNumber).toString().equals(code)) {
      dic.remove(phoneNumber);
      List<Member> member = memberService.findOneByNumber(phoneNumber);
      if (!member.isEmpty()) { // 가입되어 있으면
        retObject.put("result", member.get(0).getAccount_id());
        retObject.put("mailAuth", member.get(0).getAuthStatus());
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

  @PostMapping("/signUp")
  public JSONObject signUp(@RequestBody JSONObject object) throws UnsupportedEncodingException, MessagingException {

    JSONObject retObejct = new JSONObject();
    Member member = Member.createMember(object);
    memberService.join(member);
    sendMail(member.getEmail(), member.getAuthKey()); // 비동기처리
    retObejct.put("result", member.getAccount_id());
    retObejct.put("mailAuth", member.getAuthStatus());
    return retObejct;
  }

  @GetMapping("/signUpEmail")
  public String authEmail(@RequestParam("email") String email, @RequestParam("authKey") String authKey) {

    Member findMember = memberService.findOneByEmail(email);
    if (findMember.getAuthKey().equals(authKey)) {
      findMember.setAuthStatus(true);
      memberRepository.save(findMember);
      return "동국대학교 학생인증이 완료되었습니다. 지금부터 정상적으로 서비스 이용이 가능합니다.";
    }
    return "인증에 실패하였습니다.";
  }

  public void sendMail(String email, String authKey) throws MessagingException, UnsupportedEncodingException {

    String to = email;
    String from = "admin@koting.kr";
    String subject = "[코팅] 회원가입 인증메일입니다. ";
    String url = "http://koting.kr/signUpEmail?email=" + email + "&authKey=" + authKey;

    StringBuilder body = new StringBuilder();
    body.append("<html> <body>");
    body.append("<div> 동국대학교 학우님 반갑습니다! </div>");
    body.append("<div> 하단의 링크를 클릭해주세요! </div>");
    body.append("<a href=\"" + url + "\">인증하기</a>");
    body.append("</body> </html>");

    MimeMessage message = javaMailSender.createMimeMessage();
    MimeMessageHelper mimeMessageHelper = new MimeMessageHelper(message, true, "UTF-8");

    mimeMessageHelper.setFrom(from,"admin@koting.kr");
    mimeMessageHelper.setTo(to);
    mimeMessageHelper.setSubject(subject);
    mimeMessageHelper.setText(body.toString(), true);
    javaMailSender.send(message);
  }
}

