package com.teambB.koting.controller;

import com.teambB.koting.domain.Apply;
import com.teambB.koting.domain.ApplyStatus;
import com.teambB.koting.domain.Meeting;
import com.teambB.koting.domain.MeetingStatus;
import com.teambB.koting.domain.Member;
import com.teambB.koting.firebase.FirebaseCloudMessageService;
import com.teambB.koting.service.ApplyService;
import com.teambB.koting.service.MeetingService;
import com.teambB.koting.service.MemberService;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.Collections;
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
  FirebaseCloudMessageService firebaseCloudMessageService = new FirebaseCloudMessageService();

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
        Collections.reverse(participants);

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
      Collections.reverse(applies);

      JSONArray jArray2 = new JSONArray();
      for (Apply apply : applies) {
        // 대기 거절만 리턴
        if (apply.getApplyStatus() == ApplyStatus.ACCEPT)
          continue ;
        if (apply.getApplyStatus() == ApplyStatus.REJECT) {
          LocalDateTime createDate = apply.getCreateDate();
          LocalDateTime now = LocalDateTime.now();
          if (ChronoUnit.DAYS.between(createDate, now) >= 1) {
            continue ;
          }
        }

        Member one = memberService.findOne(apply.getMeeting().getMemberId());
        JSONObject meetingOwner = memberService.setMemberInfo(one);
        JSONObject meetingInfo = meetingService.setMeetingInfo(meetingOwner, apply.getMeeting());
        if (apply.getApplyStatus() == ApplyStatus.REJECT)
          meetingInfo.put("apply_status", "거절됨");
        else if (apply.getApplyStatus() == ApplyStatus.WAIT)
          meetingInfo.put("apply_status", "대기중");
        jArray2.add(meetingInfo);
      }

      retObject.put("myApplies", jArray2);
    }
    return retObject;
  }

  @PostMapping("/applies")
  public JSONObject applyMeeting(@RequestBody JSONObject object) throws IOException {
    JSONObject retObject = new JSONObject();

    String accountId = object.get("account_id").toString();
    Long meetingId = Long.parseLong(object.get("meeting_id").toString());

    Integer result = applyService.applyNotAvailable(accountId, meetingId);
    if (result == 0) {
      applyService.Apply(accountId, meetingId);
      Member member = memberService.findOneByAccountId(accountId);
      firebaseCloudMessageService.sendMessageTo(member.getDeviceToken(), "미팅 신청 안내", "누군가로부터 신청이 들어왔습니다.");
      retObject.put("result", "applyMeetingSuccess");
    }
    else if (result == 1) {
      retObject.put("result", "applyMeetingRejected");
    }
    else if (result == 2) {
      retObject.put("result", "applyMeetingApplied");
    }
    else if (result == 3) {
      retObject.put("result", "applyMeetingFull");
    }
    return retObject;
  }

  @Transactional
  @PostMapping("/applies/accept")
  public JSONObject acceptApply(@RequestBody JSONObject object) throws IOException {

    JSONObject retObject = new JSONObject();

    Long applyId = Long.parseLong(object.get("apply_id").toString());
    Apply apply = applyService.findOne(applyId);
    Member member = apply.getMember();
    firebaseCloudMessageService.sendMessageTo(member.getDeviceToken(), "매칭 성공", "상대방이 미팅을 수락하였습니다.");

    apply.applyAccept();
    Long ownerId = apply.getMeeting().getMemberId();
    // 내 미팅
    Member owner = memberService.findOne(ownerId);
    owner.setMyMeetingId(null);

    // 해당 미팅에 신청한 사람들
    List<Apply> applies = apply.getMeeting().getParticipants();

    // 수락할 사람 빼고 거절처리
    for (Apply apply_ : applies) {
      if (apply.getId() == apply_.getId())
        continue ;
      Apply one = applyService.findOne(apply_.getId());
      firebaseCloudMessageService.sendMessageTo(one.getMember().getDeviceToken(), "매칭 실패", "상대방이 미팅을 거절하였습니다.");
      one.rejectAccept();
    }

    // 미팅 CANCEL 변경
    Long meetingId = apply.getMeeting().getId();
    Meeting meeting = meetingService.findOne(meetingId);
    meeting.setMeetingStatus(MeetingStatus.CLOSE);

    String ApplierEmail = member.getAccount_id() + "@dgu.ac.kr";
    retObject.put("nickname", member.getNickname());
    retObject.put("result", "true");
    retObject.put("targetUserEmail", ApplierEmail);

    return retObject;
  }

  @Transactional
  @PostMapping("/applies/reject")
  public JSONObject rejectApply(@RequestBody JSONObject object) throws IOException {
    JSONObject retObject = new JSONObject();

    Long applyId = Long.parseLong(object.get("apply_id").toString());
    Apply apply = applyService.findOne(applyId);
    apply.rejectAccept();
    firebaseCloudMessageService.sendMessageTo(apply.getMember().getDeviceToken(), "매칭 실패", "상대방이 미팅을 거절하였습니다.");
    Long meetingId = apply.getMeeting().getId();
    Meeting meeting = meetingService.findOne(meetingId);
    meeting.minusApplierCnt();
//    meeting.setApplierCnt(meeting.getApplierCnt() - 1);

    retObject.put("result", "true");
    return retObject;
  }

  @GetMapping("/applies/success")
  public JSONObject getSuccessApply(@RequestParam("account_id") String accountId) {
    JSONObject retObject = new JSONObject();

    Member member = memberService.findOneByAccountId(accountId);
    List<Apply> all = applyService.findAllAccept();
    JSONArray jArray2 = new JSONArray();
    for (Apply apply : all) {
      Long ownerId = apply.getMeeting().getMemberId();
      // 내가 수락한 경우
      if (ownerId == member.getId()) {
        Long applier = apply.getMember().getId();
        Member member1 = memberService.findOne(applier);
        JSONObject meetingOwner = memberService.setMemberInfo(member1);
        jArray2.add(meetingService.setMeetingInfo(meetingOwner, apply.getMeeting()));
      }
      // 내가 신청한 경우
      else if ((apply.getMember().getId()) == member.getId()) {
        Member owner = memberService.findOne(ownerId);
        JSONObject meetingOwner = memberService.setMemberInfo(owner);
        jArray2.add(meetingService.setMeetingInfo(meetingOwner, apply.getMeeting()));
      }

      retObject.put("result", jArray2);
    }
    return retObject;
  }
}
