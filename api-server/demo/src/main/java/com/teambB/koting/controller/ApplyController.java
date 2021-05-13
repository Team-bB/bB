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
    Long id = member.getMyMeetingId();
    // 미팅 안만들어졌을 때 예외처
    Meeting myMeeting = meetingService.findOne(id);
    if (myMeeting != null) {리
        JSONObject myMeetingInfo = new JSONObject();
        JSONObject ownerInfo = new JSONObject();
        JSONObject myCreation = new JSONObject();

        ownerInfo.put("college", member.getCollege());
        ownerInfo.put("major", member.getMajor());
        ownerInfo.put("sex", member.getSex());
        ownerInfo.put("mbti", member.getMbti());
        ownerInfo.put("animal_idx", member.getAnimalIdx());
        ownerInfo.put("age", member.getAge());
        ownerInfo.put("height", member.getHeight());

        myMeetingInfo.put("owner", ownerInfo);
        myMeetingInfo.put("meeting_id", myMeeting.getId());
        myMeetingInfo.put("link", myMeeting.getLink());
        myMeetingInfo.put("player", myMeeting.getPlayer());

        myCreation.put("myMeeting", myMeetingInfo);
        List<Apply> participants = myMeeting.getParticipants();
        JSONArray jArray = new JSONArray();
        for (Apply apply : participants) {
          JSONObject myInfo = new JSONObject();
          myInfo.put("age", apply.getMember().getAge());
          myInfo.put("animal_idx", apply.getMember().getAnimalIdx());
          myInfo.put("height", apply.getMember().getHeight());
          myInfo.put("college", apply.getMember().getCollege());
          myInfo.put("major", apply.getMember().getMajor());
          myInfo.put("sex", apply.getMember().getSex());
          myInfo.put("mbti", apply.getMember().getMbti());
          myInfo.put("account_id", apply.getMember().getAccount_id());
          myInfo.put("apply_id", apply.getId().toString());
          myInfo.put("apply_stats", apply.getApplyStatus());
          jArray.add(myInfo);
        }

        myCreation.put("participant", jArray);
        retObject.put("myCreation", myCreation);
    }

    JSONArray jArray2 = new JSONArray();

    if (member.getApplies() != null) {
      List<Apply> applies = member.getApplies();

      for (Apply apply : applies) {
        // 대기 거절만 리턴
        if (apply.getApplyStatus() == ApplyStatus.ACCEPT)
          break ;
        if (apply.getApplyStatus() == ApplyStatus.REJECT)
          continue ;
        JSONObject meetingOwner = new JSONObject();
        Member one = memberService.findOne(apply.getMeeting().getOwnerId());
        meetingOwner.put("age", one.getAge());
        meetingOwner.put("animal_idx", one.getAnimalIdx());
        meetingOwner.put("height", one.getHeight());
        meetingOwner.put("college", one.getCollege());
        meetingOwner.put("major", one.getMajor());
        meetingOwner.put("sex", one.getSex());
        meetingOwner.put("mbti", one.getMbti());

        JSONObject meetingInfo = new JSONObject();
        meetingInfo.put("owner", meetingOwner);
        meetingInfo.put("meeting_id", apply.getMeeting().getId());
        meetingInfo.put("link", apply.getMeeting().getLink());
        meetingInfo.put("player", apply.getMeeting().getPlayer());
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

  @PostMapping("/applies/reject")
  public JSONObject rejectApply(@RequestBody JSONObject object) {
    JSONObject retObject = new JSONObject();

    Long applyId = Long.parseLong(object.get("apply_id").toString());
    Apply apply = applyService.findOne(applyId);
    apply.rejectAccept();

    /*
    1. 해당 Apply 거절
    2. 해당 Apply 타고, 주인의 applies에서 방금 apply 삭제
     */

    Long ownerId = apply.getMeeting().getOwnerId();
    Member owner = memberService.findOne(ownerId);
    List<Apply> applies = owner.getApplies();
    System.out.println("applies size : " + applies.size());

    for (int i = 0; i < applies.size(); i++) {
      if (applies.get(i).getId() == apply.getId()) {
        applies.remove(i);
        break ;
      }
    }
    System.out.println("applies size : " + applies.size());

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
        meetingOwner.put("age", owner.getAge());
        meetingOwner.put("animal_idx", owner.getAnimalIdx());
        meetingOwner.put("height", owner.getHeight());
        meetingOwner.put("college", owner.getCollege());
        meetingOwner.put("major", owner.getMajor());
        meetingOwner.put("sex", owner.getSex());
        meetingOwner.put("mbti", owner.getMbti());

        JSONObject meetingInfo = new JSONObject();
        meetingInfo.put("owner", meetingOwner);
        meetingInfo.put("meeting_id", apply.getMeeting().getId());
        meetingInfo.put("link", apply.getMeeting().getLink());
        meetingInfo.put("player", apply.getMeeting().getPlayer());
        jArray2.add(meetingInfo);
      }

      retObject.put("result", jArray2);
    }
    return retObject;
  }
}
