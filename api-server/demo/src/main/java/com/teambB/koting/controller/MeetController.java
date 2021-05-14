package com.teambB.koting.controller;

import com.teambB.koting.domain.Meeting;
import com.teambB.koting.service.MeetingService;
import com.teambB.koting.domain.Member;
import com.teambB.koting.service.MemberService;
import lombok.RequiredArgsConstructor;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import java.util.List;

@RestController
@RequiredArgsConstructor
public class MeetController {

  @Autowired private final MemberService memberService;
  @Autowired private final MeetingService meetingService;

  @GetMapping("/meetings")
  public JSONObject getMeetingList(@RequestParam("account_id") String account_id) {
    List<Meeting> meetingList = meetingService.findAll();
    Member member = memberService.findOneByAccountId(account_id);
    JSONObject retObject = new JSONObject();
    JSONArray jArray = new JSONArray();

    // 내가 만든 미팅 없을 때 예외 막기

    for (Meeting meeting : meetingList) {
      if (member.getId() == meeting.getOwnerId()) {
        continue ;
      }
      JSONObject sObject = new JSONObject();
      JSONObject owner = new JSONObject();
      Long ownerId = meeting.getOwnerId();
      Member owner_ = memberService.findOne(ownerId);
      memberService.setMemberInfo(owner, owner_);
      meetingService.setMeetingInfo(sObject, owner, meeting);
      jArray.add(sObject);
    }
    retObject.put("meeting", jArray); //배열을 넣음

    JSONObject myInfo = new JSONObject();
    JSONObject owner = new JSONObject();
    memberService.setMemberInfo(owner, member);

    if (member.getMyMeetingId() != null) {
      Meeting myMeeting = meetingService.findOne(member.getMyMeetingId());
      meetingService.setMeetingInfo(myInfo, owner, myMeeting);
      retObject.put("myMeeting", myInfo);
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
}
