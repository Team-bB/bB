package com.teambB.koting.controller;

import com.teambB.koting.domain.Apply;
import com.teambB.koting.domain.ApplyStatus;
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
import org.springframework.transaction.annotation.Transactional;
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

    if (member.getMyMeetingId() != null) {
      Meeting myMeeting = meetingService.findOne(member.getMyMeetingId());
      JSONObject myMeetingInfo = new JSONObject();
      JSONObject ownerInfo = new JSONObject();
      JSONObject myCreation = new JSONObject();
      memberService.setMemberInfo(ownerInfo, member);
      meetingService.setMeetingInfo(myMeetingInfo, ownerInfo, myMeeting);

      myCreation.put("myMeeting", myMeetingInfo);

      if (myMeeting.getParticipants() != null) {
        List<Apply> participants = myMeeting.getParticipants();

        JSONArray jArray = new JSONArray();
        for (Apply apply : participants) {
          if (apply.getApplyStatus() == ApplyStatus.ACCEPT) {
            jArray.clear();
            break ;
          }
          if (apply.getApplyStatus() == ApplyStatus.REJECT)
            continue;
          JSONObject myInfo = new JSONObject();

          memberService.setMemberInfo(myInfo, apply.getMember());
          myInfo.put("account_id", apply.getMember().getAccount_id());
          myInfo.put("apply_id", apply.getId().toString());
          myInfo.put("apply_status", apply.getApplyStatus());

          jArray.add(myInfo);
        }
        if (!jArray.isEmpty())
          myCreation.put("participant", jArray);
      }

      retObject.put("myCreation", myCreation);
    }

    if (member.getApplies() != null) {
      List<Apply> applies = member.getApplies();
      JSONArray jArray2 = new JSONArray();
      for (Apply apply : applies) {
        // 대기 거절만 리턴
        if (apply.getApplyStatus() == ApplyStatus.ACCEPT)
          break ;
        if (apply.getApplyStatus() == ApplyStatus.REJECT)
          continue ;
        JSONObject meetingOwner = new JSONObject();
        Member one = memberService.findOne(apply.getMeeting().getOwnerId());
        memberService.setMemberInfo(meetingOwner, one);

        JSONObject meetingInfo = new JSONObject();
        meetingService.setMeetingInfo(meetingInfo, meetingOwner, apply.getMeeting());
        jArray2.add(meetingInfo);
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

  @Transactional
  @PostMapping("/applies/accept")
  public JSONObject acceptApply(@RequestBody JSONObject object) {
    JSONObject retObject = new JSONObject();

    Long applyId = Long.parseLong(object.get("apply_id").toString());
    Apply apply = applyService.findOne(applyId);
    apply.applyAccept();

    // 해당 미팅에 신청한 사람들
    List<Apply> applies = apply.getMeeting().getParticipants();

    // 수락할 사람 빼고 거절처리
    for (Apply apply_ : applies) {
      if (apply.getId() == apply_.getId())
        continue ;
      Apply one = applyService.findOne(apply_.getId());
      one.rejectAccept();
    }

    // 전체 비우기

    retObject.put("result", "true");
    return retObject;
  }

  @Transactional
  @PostMapping("/applies/reject")
  public JSONObject rejectApply(@RequestBody JSONObject object) {
    JSONObject retObject = new JSONObject();

    Long applyId = Long.parseLong(object.get("apply_id").toString());
    Apply apply = applyService.findOne(applyId);
    apply.rejectAccept();

    retObject.put("result", "true");
    return retObject;
  }

  @GetMapping("/applies/success")
  public JSONObject getSuccessApply(@RequestParam("account_id") String accountId) {
    JSONObject retObject = new JSONObject();

    Member member = memberService.findOneByAccountId(accountId);
    List<Apply> all = applyService.findAll();
    JSONArray jArray2 = new JSONArray();
    for (Apply apply : all) {
      Long ownerId = apply.getMeeting().getOwnerId();
      if ((ownerId == member.getId())
          || (apply.getMember().getId()) == member.getId()) {

        JSONObject meetingOwner = new JSONObject();
        Member owner = memberService.findOne(ownerId);
        memberService.setMemberInfo(meetingOwner, owner);

        JSONObject meetingInfo = new JSONObject();
        meetingService.setMeetingInfo(meetingInfo, meetingOwner, apply.getMeeting());
        jArray2.add(meetingInfo);
      }

      retObject.put("result", jArray2);
    }
    return retObject;
  }
}
