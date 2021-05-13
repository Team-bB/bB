package com.teambB.koting.service;

import com.teambB.koting.domain.Meeting;
import com.teambB.koting.repository.MeetingRepository;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.json.simple.JSONObject;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
@RequiredArgsConstructor
public class MeetingService {

  private final MeetingRepository meetingRepository;

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

  public void setMeetingInfo(JSONObject object, JSONObject owner, Meeting meeting) {
    object.put("owner", owner);
    object.put("meeting_id", meeting.getId());
    object.put("player", meeting.getPlayer());
    object.put("link", meeting.getLink());
  }
}
