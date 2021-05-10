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
    JSONObject retObject = new JSONObject();
    JSONArray jArray = new JSONArray();

//    for (Meeting meeting : meetingList)
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

    JSONObject myInfo = new JSONObject();

    Member myMember = memberService.findOneByAccountId(account_id);
    JSONObject owner = new JSONObject();
    owner.put("age", myMember.getAge());
    owner.put("animal_idx", myMember.getAnimalIdx());
    owner.put("college", myMember.getCollege());
    owner.put("height", myMember.getHeight());
    owner.put("major", myMember.getMajor());
    owner.put("sex", myMember.getSex());
    owner.put("mbti", myMember.getMbti());

    Meeting myMeeting = myMember.getMyMeeting();

    myInfo.put("owner", owner);
    myInfo.put("player", myMeeting.getPlayer());
    myInfo.put("link", myMeeting.getLink());

    retObject.put("myMeeting", myInfo);

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

  @GetMapping("/meetings/matched")
  public JSONObject getMatchedMeeting(@RequestParam("account_id") String account_id) {
    Member accountID = memberService.findOneByAccountId(account_id);
    List<Meeting> successMeeting = accountID.getSuccessMeeting();
    JSONObject retObject = new JSONObject();
    JSONArray jArray = new JSONArray();
    if (!successMeeting.isEmpty()) {
      for (int i = 0; i < successMeeting.size(); i++)
      {
        JSONObject sObject = new JSONObject();
        JSONObject owner = new JSONObject();
        owner.put("age", successMeeting.get(i).getOwner().getAge());
        owner.put("animal_idx", successMeeting.get(i).getOwner().getAnimalIdx());
        owner.put("college", successMeeting.get(i).getOwner().getCollege());
        owner.put("height", successMeeting.get(i).getOwner().getHeight());
        owner.put("major", successMeeting.get(i).getOwner().getMajor());
        owner.put("sex", successMeeting.get(i).getOwner().getSex());
        owner.put("mbti", successMeeting.get(i).getOwner().getMbti());
//        sObject.put("owner", owner);
//        sObject.put("meeting_id", successMeeting.get(i).getId());
//        sObject.put("player", successMeeting.get(i).getPlayer());
//        sObject.put("link", successMeeting.get(i).getLink());
        jArray.add(sObject);
      }
      retObject.put("meeting", jArray);//배열을 넣음
    }
    return retObject;
  }
}
