package com.teambB.koting.controller;

import com.teambB.koting.domain.Meeting;
import com.teambB.koting.service.MeetingService;
import com.teambB.koting.domain.Member;
import com.teambB.koting.service.MemberService;
import java.io.IOException;
import lombok.RequiredArgsConstructor;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class MeetController {

  @Autowired private final MemberService memberService;
  @Autowired private final MeetingService meetingService;

  @GetMapping("/meetings")
  public JSONObject getMeetingList(@RequestParam("account_id") String account_id) {
    JSONObject retObject = new JSONObject();

    Member member = memberService.findOneByAccountId(account_id);

    if (meetingService.findAll() != null) {
      retObject.put("meeting", meetingService.getMeetingList(member));
    }


    if (member.getMyMeetingId() != null) {
      JSONObject owner = memberService.setMemberInfo(member);
      Meeting myMeeting = meetingService.findOne(member.getMyMeetingId());

      retObject.put("myMeeting", meetingService.setMeetingInfo(owner, myMeeting));
    }
    return retObject;
  }

  @Transactional
  @PostMapping("/meetings")
  public JSONObject createMeeting(@RequestBody JSONObject object) {
    JSONObject retObject = new JSONObject();

    String accountId = object.get("account_id").toString();
    String players = object.get("players").toString();
    String link = object.get("link").toString();

    Member member = memberService.findOneByAccountId(accountId);
    if (member.getMyMeetingId() != null) {
      retObject.put("result", "createFail");
    }
    else {
      Meeting meeting = Meeting.createMeeting(member, players, link);
      meetingService.join(meeting);
      member.setMyMeetingId(meeting.getId());
      retObject.put("result", "createSuccess");
    }
    return retObject;
  }

  @DeleteMapping("/meetings")
  public JSONObject deleteMeeting(@RequestBody JSONObject object) throws IOException {
    JSONObject retObject = new JSONObject();

    String accountId = object.get("account_id").toString();
    meetingService.deleteMeeting(accountId);
    retObject.put("result", "true");
    return retObject;
  }
}
