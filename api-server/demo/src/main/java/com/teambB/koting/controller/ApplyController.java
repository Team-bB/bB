package com.teambB.koting.controller;

import com.teambB.koting.domain.Apply;
import com.teambB.koting.domain.Meeting;
import com.teambB.koting.domain.Member;
import com.teambB.koting.service.ApplyService;
import com.teambB.koting.service.MeetingService;
import com.teambB.koting.service.MemberService;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class ApplyController {

  @Autowired private final MeetingService meetingService;
  @Autowired private final MemberService memberService;
  @Autowired private final ApplyService applyService;

  @GetMapping("/applies")
  public JSONObject getMyMeetingInfo(@RequestParam("account_id") String accountId) {
    JSONObject retObject = new JSONObject();
    JSONArray jArray = new JSONArray();

    Member member = memberService.findOneByAccountId(accountId);
    Meeting myMeeting = member.getMyMeeting();
    if (myMeeting != null) {
      List<Apply> participants = myMeeting.getParticipants();
      JSONObject myInfo = new JSONObject();
      for (int i = 0; i < participants.size(); i++) {
        myInfo.put("age", participants.get(i).getMember().getAge());
        myInfo.put("animal_idx", participants.get(i).getMember().getAnimalIdx());
        myInfo.put("height", participants.get(i).getMember().getHeight());
        myInfo.put("college", participants.get(i).getMember().getCollege());
        myInfo.put("major", participants.get(i).getMember().getMajor());
        myInfo.put("sex", participants.get(i).getMember().getSex());
        jArray.add(myInfo);
      }
      retObject.put("myMeeting", jArray);
    }

    JSONArray jArray2 = new JSONArray();
    if (member.getApplies() != null) {
      List<Apply> applies = member.getApplies();
      JSONObject myApplies = new JSONObject();
      for (int i = 0; i < applies.size(); i++) {
        myApplies.put("age", applies.get(i).getMember().getAge());
        myApplies.put("animal_idx", applies.get(i).getMember().getAnimalIdx());
        myApplies.put("height", applies.get(i).getMember().getHeight());
        myApplies.put("college", applies.get(i).getMember().getCollege());
        myApplies.put("major", applies.get(i).getMember().getMajor());
        myApplies.put("sex", applies.get(i).getMember().getSex());
        jArray2.add(myApplies);
      }
      retObject.put("myApplies", jArray2);
    }
    return retObject;
  }

  @PostMapping("/applies")
  public JSONObject applyMeeting(@RequestBody JSONObject object) {

    JSONObject retObject = new JSONObject();
    String accountId = object.get("account_id").toString();
    Member member = memberService.findOneByAccountId(accountId);

    Long meetingId = Long.parseLong(object.get("meeting_id").toString());
    Meeting meeting = meetingService.findOne(meetingId);

    Apply apply = Apply.createApply(member, meeting);
    applyService.join(apply);
    retObject.put("result", "applyMeetingSuccess");

    return retObject;
  }
}
