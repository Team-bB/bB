package com.teambB.koting.controller;

import com.teambB.koting.domain.Meeting;
import com.teambB.koting.service.MeetingService;
import com.teambB.koting.domain.Member;
import com.teambB.koting.service.MemberService;
import lombok.RequiredArgsConstructor;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import java.util.List;

@RestController
@RequiredArgsConstructor
public class MeetController {

  @Autowired private final MemberService memberService;
  @Autowired private final MeetingService meetingService;

  @GetMapping("/meetings")
  public JSONObject getMeetingList() {
    List<Meeting> meetingList = meetingService.findAll();
    JSONObject retObject = new JSONObject();

    JSONArray jArray = new JSONArray();

    for (int i = 0; i < meetingList.size(); i++)
    {
      JSONObject sObject = new JSONObject();
      JSONObject owner = new JSONObject();
      owner.put("age", meetingList.get(i).getOwner().getAge());
      owner.put("animal_idx", meetingList.get(i).getOwner().getAnimalIdx());
      owner.put("college", meetingList.get(i).getOwner().getCollege());
      owner.put("height", meetingList.get(i).getOwner().getHeight());
      owner.put("major", meetingList.get(i).getOwner().getMajor());
      owner.put("sex", meetingList.get(i).getOwner().getSex());
      owner.put("mbti", meetingList.get(i).getOwner().getMbti());
      sObject.put("owner", owner);
      sObject.put("meeting_id", meetingList.get(i).getId());
      sObject.put("player", meetingList.get(i).getPlayer());
      sObject.put("link", meetingList.get(i).getLink());
      jArray.add(sObject);
    }
    retObject.put("meeting", jArray);//배열을 넣음

    return retObject;
  }

  @PostMapping("/meetings")
  public JSONObject createMeeting(@RequestBody JSONObject object) {

    JSONObject retObject = new JSONObject();
    String accountId = object.get("account_id").toString();
    String players = object.get("players").toString();
    String link = object.get("link").toString();
    Member member = memberService.findOneByAccountId(accountId);
    if (member.getMyMeeting() != null) {
      retObject.put("result", "createFail");
    }
    else {
      Meeting meeting = Meeting.createMeeting(member, players, link);
      meetingService.join(meeting);
      retObject.put("result", "createSuccess");
    }
    return retObject;
  }
}
