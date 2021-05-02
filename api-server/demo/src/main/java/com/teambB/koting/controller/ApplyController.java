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

    Member member = memberService.findOneByAccountId(accountId);
    Meeting myMeeting = member.getMyMeeting();


    if (myMeeting != null) {
        JSONObject myMeetingInfo = new JSONObject();

        JSONObject ownerInfo = new JSONObject();
        ownerInfo.put("college", member.getCollege());
        ownerInfo.put("major", member.getMajor());
        ownerInfo.put("sex", member.getSex());
        ownerInfo.put("mbti", member.getMbti());
        ownerInfo.put("animal_idx", member.getAnimalIdx());
        ownerInfo.put("age", member.getAge());
        ownerInfo.put("height", member.getHeight());
        myMeetingInfo.put("owner", ownerInfo);

        myMeetingInfo.put("meeting_id", member.getMyMeeting().getId());

        myMeetingInfo.put("link", member.getMyMeeting().getLink());

        myMeetingInfo.put("player", member.getMyMeeting().getPlayer());

        List<Apply> participants = myMeeting.getParticipants();
        JSONArray jArray = new JSONArray();
        for (int i = 0; i < participants.size(); i++) {
          JSONObject myInfo = new JSONObject();
          myInfo.put("age", participants.get(i).getMember().getAge());
          myInfo.put("animal_idx", participants.get(i).getMember().getAnimalIdx());
          myInfo.put("height", participants.get(i).getMember().getHeight());
          myInfo.put("college", participants.get(i).getMember().getCollege());
          myInfo.put("major", participants.get(i).getMember().getMajor());
          myInfo.put("sex", participants.get(i).getMember().getSex());
          myInfo.put("mbti", participants.get(i).getMember().getMbti());
          jArray.add(myInfo);
        }
        myMeetingInfo.put("participant", jArray);

        retObject.put("myMeeting", myMeetingInfo);
    }

    JSONArray jArray2 = new JSONArray();
    if (member.getApplies() != null) {
      List<Apply> applies = member.getApplies();
      for (int i = 0; i < applies.size(); i++) {
        JSONObject myApplies = new JSONObject();
        myApplies.put("age", applies.get(i).getMeeting().getOwner().getAge());
        myApplies.put("animal_idx", applies.get(i).getMeeting().getOwner().getAnimalIdx());
        myApplies.put("height", applies.get(i).getMeeting().getOwner().getHeight());
        myApplies.put("college", applies.get(i).getMeeting().getOwner().getCollege());
        myApplies.put("major", applies.get(i).getMeeting().getOwner().getMajor());
        myApplies.put("sex", applies.get(i).getMeeting().getOwner().getSex());
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
