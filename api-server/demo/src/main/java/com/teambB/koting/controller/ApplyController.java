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

    // 내 미팅이 존재하면
    if (member.getMyMeetingId() != null) {
      Meeting myMeeting = meetingService.findOne(member.getMyMeetingId());
      JSONObject ownerInfo = memberService.setMemberInfo(member);
      JSONObject myCreation = new JSONObject();

      myCreation.put("myMeeting", meetingService.setMeetingInfo(ownerInfo, myMeeting));

      // 내 미팅에 신청한 사람이 존재하면
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
          JSONObject myInfo = memberService.setMemberInfo(apply.getMember());
          myInfo.put("account_id", apply.getMember().getAccount_id());
          myInfo.put("apply_id", apply.getId().toString());

          jArray.add(myInfo);
        }
        if (!jArray.isEmpty())
          myCreation.put("participant", jArray);
      }

      retObject.put("myCreation", myCreation);
    }

    // 내가 신청한 미팅이 존재하면
    if (member.getApplies() != null) {
      List<Apply> applies = member.getApplies();
      JSONArray jArray2 = new JSONArray();
      for (Apply apply : applies) {
        // 대기 거절만 리턴
        if (apply.getApplyStatus() == ApplyStatus.ACCEPT)
          continue ;

        Member one = memberService.findOne(apply.getMeeting().getOwnerId());
        JSONObject meetingOwner = memberService.setMemberInfo(one);

        jArray2.add(meetingService.setMeetingInfo(meetingOwner, apply.getMeeting()));
      }

      retObject.put("myApplies", jArray2);
    }
    return retObject;
  }

  @PostMapping("/applies")
  public JSONObject applyMeeting(@RequestBody JSONObject object) {
    JSONObject retObject = new JSONObject();

    String accountId = object.get("account_id").toString();
    Long meetingId = Long.parseLong(object.get("meeting_id").toString());

    applyService.Apply(accountId, meetingId);
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

        Member owner = memberService.findOne(ownerId);
        JSONObject meetingOwner = memberService.setMemberInfo(owner);

        jArray2.add(meetingService.setMeetingInfo(meetingOwner, apply.getMeeting()));
      }

      retObject.put("result", jArray2);
    }
    return retObject;
  }
}
