package com.teambB.koting.controller;

import java.util.List;
import com.teambB.koting.domain.Member;
import com.teambB.koting.service.MemberService;
import lombok.RequiredArgsConstructor;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class MeetController {

  @Autowired private final MemberService memberService;
  @Autowired private final Member member;

  @PostMapping("/checkStatus")
  public JSONObject checkStatus(@RequestBody JSONObject object) {

    JSONObject retObject = new JSONObject();
    String accountId = object.get("account_id").toString();
    List<Member> member = memberService.findOneByAccountId(accountId);
    retObject.put("result", member.get(0).getAuthStatus());
    return retObject;
  }
}
