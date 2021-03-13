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
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class MeetingService {

  private final MeetingRepository meetingRepository;
  private final MemberRepository memberRepository;

  @Transactional
  public void saveMeeting(Meeting meeting) {
    meetingRepository.save(meeting);
  }

  public List<Meeting> findMeetings() {
    return meetingRepository.findAll();
  }

  public Meeting findOne(Long meetingId) {
    return meetingRepository.findById(meetingId);
  }
}
