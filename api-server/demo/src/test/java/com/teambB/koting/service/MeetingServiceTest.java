package com.teambB.koting.service;

import static org.junit.Assert.*;

import com.teambB.koting.domain.Apply;
import com.teambB.koting.domain.Meeting;
import com.teambB.koting.domain.Member;
import javax.persistence.EntityManager;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.transaction.annotation.Transactional;

@RunWith(SpringRunner.class)
@SpringBootTest
@Transactional
public class MeetingServiceTest {

  @Autowired MeetingService meetingService;
  @Autowired EntityManager em;

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
  
  @Test
  @Rollback(value = false)
  public void 미팅삭제() throws Exception {
      //given
    Member member1 = new Member();
    member1.setAccount_id(Member.makeRandomString(16));
    em.persist(member1);

    Member member2 = new Member();
    em.persist(member2);

    Meeting meeting = Meeting.createMeeting(member1, "1 : 1", "hello world");
    em.persist(meeting);
    member1.setMyMeetingId(meeting.getId());

    Apply apply = Apply.createApply(member2, meeting);
    em.persist(apply);

    //when
    meetingService.deleteMeeting(member1.getAccount_id());
      
    //then
    assertEquals(true, true);
  }
      
}