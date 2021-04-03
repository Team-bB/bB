package com.teambB.koting.controller;

import com.teambB.koting.domain.Meeting;
import com.teambB.koting.service.MeetingService;
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
  @Autowired private final MeetingService meetingService;

  @PostMapping("/meetings")
  public JSONObject createMeeting(@RequestBody JSONObject object) {

    JSONObject retObject = new JSONObject();
    String accountId = object.get("account_id").toString();
    String players = object.get("players").toString();
    Member member = memberService.findOneByAccountId(accountId);
    if (member.getMyMeeting() != null) {
      retObject.put("result", "createFail");
    }
    else {
      Meeting meeting = Meeting.createMeeting(member, Integer.parseInt(players));
      meetingService.join(meeting);
      retObject.put("result", "createSuccess");
    }
    return retObject;
  }
}
