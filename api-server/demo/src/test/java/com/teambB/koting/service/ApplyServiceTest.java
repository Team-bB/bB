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
    assertEquals(apply.getMeeting().getOwnerId(), member1.getId());
    assertEquals(apply.getMeeting().getId(), meeting.getId());
  }
}