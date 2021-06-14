package com.teambB.koting.service;

import com.teambB.koting.domain.Apply;
import com.teambB.koting.domain.Meeting;
import com.teambB.koting.domain.MeetingStatus;
import com.teambB.koting.domain.Member;
import com.teambB.koting.firebase.FirebaseCloudMessageService;
import com.teambB.koting.firebase.FirebaseService;
import com.teambB.koting.repository.MeetingRepository;
import com.teambB.koting.repository.MemberRepository;
import java.io.IOException;
import java.time.format.DateTimeFormatter;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
@RequiredArgsConstructor
public class MeetingService {

  private final MeetingRepository meetingRepository;
  private final MemberRepository memberRepository;
  private final MemberService memberService;
  private final ApplyService applyService;

  public Long join(Meeting meeting) {
    meetingRepository.save(meeting);
    return meeting.getId();
  }

  public Meeting findOne(Long id) {
    return meetingRepository.findById(id);
  }

  public List<Meeting> findAll() {
    return meetingRepository.findAll();
  }

  public JSONObject setMeetingInfo(JSONObject owner, Meeting meeting) {
    JSONObject retObject = new JSONObject();

    retObject.put("owner", owner);
    retObject.put("meeting_id", meeting.getId());
    retObject.put("player", meeting.getPlayer());
    retObject.put("link", meeting.getLink());
    retObject.put("applierCnt", meeting.getApplierCnt());
    retObject.put("date", meeting.getCreateDate().format(DateTimeFormatter.ISO_DATE));
    return retObject;
  }

  public JSONArray getMeetingList(Member member) {
    JSONArray jArray = new JSONArray();

    List<Meeting> meetingList = findAll();
    Collections.reverse(meetingList);
    for (Meeting meeting : meetingList) {
      /*
      보이면 안되는 미팅들
      1. 내 미팅
      2. 닫힌 미팅(성사되었거나, 삭제한 미팅)
      3. 같은 과인 미팅
      4. 나랑 성별이 같은 미팅
      5. 내가 차단한 사용자
      6. 나를 차단한 사용
       */
      Long ownerId = meeting.getMemberId();
      Member owner_ = memberService.findOne(ownerId);
      JSONObject owner = memberService.setMemberInfo(owner_);

      if (member.getId() == meeting.getMemberId()
          || meeting.getMeetingStatus() == MeetingStatus.CLOSE
          || member.getMajor().equals(owner_.getMajor())
          || member.getSex().equals(owner_.getSex())
          || isBlock(member, meeting)) {
        continue ;
      }

      jArray.add(setMeetingInfo(owner, meeting));
    }
    return jArray;
  }

  private boolean isBlock(Member member, Meeting meeting) {
    // 내가 차단한 사람
    for (Long id : member.getBlock()) {
      if (id == meeting.getMemberId()) {
        return true;
      }
    }

    // 나를 차단한 사람
    for (Long id : member.getBlocked()) {
      if (id == meeting.getMemberId()) {
        return true;
      }
    }
    return false;
  }

  public void deleteMeeting(String accountId) throws IOException {
    Member member = memberRepository.findByAccountId(accountId);

    // 삭제 말고 전체 거절처리
    Meeting myMeeting = meetingRepository.findById(member.getMyMeetingId());
    for (Apply apply_ : myMeeting.getParticipants()) {
      Apply one = applyService.findOne(apply_.getId());
      one.rejectAccept();
      FirebaseCloudMessageService firebaseCloudMessageService = new FirebaseCloudMessageService();
      FirebaseService.sendReject(one.getMember().getDeviceToken());
//      firebaseCloudMessageService.sendMessageTo(one.getMember().getDeviceToken(), "매칭 실패", "상대방이 미팅을 거절하였습니다.");
    }
    myMeeting.setMeetingStatus(MeetingStatus.CLOSE);
    member.setMyMeetingId(null);
  }
}
