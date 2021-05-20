package com.teambB.koting.service;

import com.teambB.koting.domain.Meeting;
import com.teambB.koting.domain.MeetingStatus;
import com.teambB.koting.domain.Member;
import com.teambB.koting.repository.MeetingRepository;
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
  private final MemberService memberService;

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
    return retObject;
  }

  public JSONArray getMeetingList(Member member) {
    JSONArray jArray = new JSONArray();

    List<Meeting> meetingList = findAll();
    for (Meeting meeting : meetingList) {
      /*
      보이면 안되는 미팅들
      1. 내 미팅
      2. 닫힌 미팅(성사되었거나, 삭제한 미팅)
      3. 같은 과인 미팅
      4. 나랑 성별이 같은 미팅
       */
      Long ownerId = meeting.getMemberId();
      Member owner_ = memberService.findOne(ownerId);
      JSONObject owner = memberService.setMemberInfo(owner_);

      if (member.getId() == meeting.getMemberId()
          || meeting.getMeetingStatus() == MeetingStatus.CLOSE
          || member.getMajor().equals(owner_.getMajor())
          || member.getSex().equals(owner_.getSex())) {
        continue ;
      }
      jArray.add(setMeetingInfo(owner, meeting));
    }
    return jArray;
  }
}
