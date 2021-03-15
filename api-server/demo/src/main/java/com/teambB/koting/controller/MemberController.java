package com.teambB.koting.controller;

import com.teambB.koting.domain.Meeting;
import com.teambB.koting.domain.Member;
import com.teambB.koting.repository.MemberRepository;
import com.teambB.koting.service.MemberService;
import java.io.UnsupportedEncodingException;
import java.util.Random;
import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.json.simple.JSONObject;
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

  @GetMapping("/")
  public Object testGet(@RequestBody Object params) {
    return params;
  }

  @PostMapping("/")
  public Object testPost(@RequestBody Object params) {
    return params;
  }

  @PostMapping("/signUp")
  public boolean signUp(@RequestBody JSONObject object) throws UnsupportedEncodingException, MessagingException {
    String email = object.get("email").toString();
    String authKey = makeRandomString(6);
    Member member = Member.createMember(object, authKey);
    memberService.join(member);
    sendMail(email, authKey);
    return true;
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

  @PostMapping("/auth")
  public boolean sendCode(@RequestBody JSONObject object) {

    String phoneNumber = object.get("phoneNumber").toString();
    String api_key = "NCSRF0PYIQASDVPU";
    String api_secret = "CR2RF1F8AWBNK406P1RD51VGBWK1881M";
    Message coolsms = new Message(api_key, api_secret);
    String code = makeRandomNumber(6);
    String message = "[코팅] 인증번호[" + code + "]를 입력해주세요.";

    System.out.println(code);

    dic.put(phoneNumber, code);

    HashMap<String, String> params = new HashMap<String, String>();
    params.put("to", phoneNumber);
    params.put("from", "01057952740");
    params.put("type", "SMS");
    params.put("text", message);
    params.put("app_version", "test app 1.2");

    /*
    try {
      JSONObject obj = (JSONObject) coolsms.send(params);
      System.out.println(obj.toString());
    } catch (CoolsmsException e) {
      System.out.println(e.getMessage());
      System.out.println(e.getCode());
      return false;
    }
     */

    return true;
  }

  @PostMapping("/auth/number")
  public boolean checkCode(@RequestBody JSONObject object) {
    String phoneNumber = object.get("phoneNumber").toString();
    String code = object.get("code").toString();
    if (dic.get(phoneNumber).toString().equals(code)) {  // 인증번호 일치
      // 2가지 경우
      // 1. 가입 된 경우   -> 필요한 정보들 전체 리턴
      // 2. 미 가입된 경우  -> 회원가입 창으로 보내게끔 리턴
      dic.remove(phoneNumber);
      return true;
    }
    dic.remove(phoneNumber);                  // 인증번호 불 일치
    return false;
  }

  public String makeRandomNumber(int length) {
    Random rand = new Random();
    String numStr = "";
    for (int i = 0; i < length; i++) {
      String ran = Integer.toString(rand.nextInt(10));
      numStr += ran;
    }
    System.out.println(numStr);
    return numStr;
  }

  public String makeRandomString(int length) {
    StringBuffer buffer = new StringBuffer();
    Random random = new Random();

    String chars[] = "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,1,2,3,4,5,6,7,8,9".split(",");

    for (int i = 0; i < length; i++) {
      buffer.append(chars[random.nextInt(chars.length)]);
    }
    return buffer.toString();
  }

  public void sendMail(String email, String authKey) throws MessagingException, UnsupportedEncodingException {

    String to = "trhjh@naver.com";
    String from = "admin@koting.com";
    String subject = "[Koting] 회원가입 인증메일입니다. ";
    String url = "http://15.165.143.51/signUpEmail?email=" + email + "&authKey=" + authKey;

    StringBuilder body = new StringBuilder();
    body.append("<html> <body>");
    body.append("<div> 아래의 링크를 클릭해주세요!</div>");
    body.append("<br><div>" + url + "</div");
    body.append("</body> </html>");

    MimeMessage message = javaMailSender.createMimeMessage();
    MimeMessageHelper mimeMessageHelper = new MimeMessageHelper(message, true, "UTF-8");

    mimeMessageHelper.setFrom(from,"admin@koting.co.kr");
    mimeMessageHelper.setTo(to);
    mimeMessageHelper.setSubject(subject);
    mimeMessageHelper.setText(body.toString(), true);
    javaMailSender.send(message);
  }
}

