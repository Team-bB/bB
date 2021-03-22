package com.teambB.koting.service;

import com.teambB.koting.domain.Meeting;
import com.teambB.koting.repository.MeetingRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
@RequiredArgsConstructor
public class MeetingService {

  @Autowired private final MeetingRepository meetingRepository;

  public Long join(Meeting meeting) {
    meetingRepository.save(meeting);
    return meeting.getId();
  }

  public Meeting findOne(Long id) {
    return meetingRepository.findById(id);
  }
}
