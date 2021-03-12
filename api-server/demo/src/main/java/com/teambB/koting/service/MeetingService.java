package com.teambB.koting.service;

import java.util.List;
import com.teambB.koting.domain.Meeting;
import com.teambB.koting.repository.MeetingRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class MeetingService {
  private final MeetingRepository meetingRepository;

  @Transactional
  public void saveMeeting(Meeting meeting) {
    meetingRepository.save(meeting);
  }

  public List<Meeting> findMeetings() {
    return meetingRepository.findAll();
  }

  public Meeting findOne(Long meetingId) {
    return meetingRepository.findOne(meetingId);
  }
}
