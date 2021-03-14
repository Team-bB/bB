package com.teambB.koting.service;

import com.teambB.koting.domain.Apply;
import com.teambB.koting.domain.Member;
import com.teambB.koting.repository.MemberRepository;
import java.util.List;
import com.teambB.koting.domain.Meeting;
import com.teambB.koting.repository.MeetingRepository;
import lombok.RequiredArgsConstructor;
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

  public List<Meeting> findMeetings() {
    return meetingRepository.findAll();
  }

  @Transactional(readOnly = true)
  public Meeting findOne(Long id) {
    return meetingRepository.findById(id);
  }
}
