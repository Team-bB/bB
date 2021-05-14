package com.teambB.koting.service;

import static org.junit.Assert.*;

import com.teambB.koting.domain.Meeting;
import com.teambB.koting.domain.Member;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.transaction.annotation.Transactional;

@RunWith(SpringRunner.class)
@SpringBootTest
@Transactional
public class MeetingServiceTest {

  @Autowired MeetingService meetingService;

  @Test
  public void 미팅생성() throws Exception {
      //given
    Member member = new Member();
    Meeting meeting = Meeting.createMeeting(member, "1 : 1", "open.kakao.com");

    //when
    Long id = meetingService.join(meeting);

    //then
    assertEquals(meeting, meetingService.findOne(id));
  }
}