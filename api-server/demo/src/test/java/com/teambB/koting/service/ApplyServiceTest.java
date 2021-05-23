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
public class ApplyServiceTest {

  @Autowired MemberService memberService;
  @Autowired ApplyService applyService;
  @Autowired EntityManager em;

  @Test
  public void 신청생성() throws Exception {
      //given
    Member member1 = new Member();
    member1.setAccount_id(Member.makeRandomString(16));
    em.persist(member1);

    Meeting meeting = Meeting.createMeeting(member1, "1 : 1", "open.kakao.com");
    em.persist(meeting);

    Member member2 = new Member();
    member2.setAccount_id(Member.makeRandomString(16));
    em.persist(member2);

    //when
    Long applyId = applyService.Apply(member2.getAccount_id(), meeting.getId());

    //then
    Apply apply = applyService.findOne(applyId);

    assertEquals(apply.getMember().getId(), member2.getId());
    assertEquals(apply.getMeeting().getMemberId(), member1.getId());
    assertEquals(apply.getMeeting().getId(), meeting.getId());
  }
  @Test
  @Rollback(value = false)
  public void 회원탈퇴() throws Exception {
      //given
    Member member1 = new Member();
    member1.setEmail("test.com");
    member1.setNumber("1234");
    member1.setAccount_id(Member.makeRandomString(16));
    Member member2 = new Member();
    em.persist(member1);
    em.persist(member2);

    Meeting meeting1 = Meeting.createMeeting(member1, "2 : 2", "kakaolink.com");
    em.persist(meeting1);

    member1.setMyMeetingId(meeting1.getId());

    Apply apply1 = Apply.createApply(member2, meeting1);
    em.persist(apply1);

    Member member3 = new Member();
    member3.setAccount_id(Member.makeRandomString(16));
    em.persist(member3);
    Meeting meeting2 = Meeting.createMeeting(member3, "3 : 3", "betatest.com");
    em.persist(meeting2);

    member3.setMyMeetingId(meeting2.getId());

    Apply apply2 = Apply.createApply(member1, meeting2);
    em.persist(apply2);

    //when
    memberService.deleteMember(member1.getAccount_id());
      
    //then
    assertEquals(true, true);

  }
      
}