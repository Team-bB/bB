package com.teambB.koting.service;

import static org.junit.Assert.*;

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
public class MemberServiceTest {

  @Autowired MemberService memberService;

  @Test
  public void 회원가입() throws Exception {
      //given
    Member member = new Member();
    member.setAccount_id(Member.makeRandomString(16));
    member.setEmail("trhjh@naver.com");
    member.setNumber("01057952740");

      //when
    Long memberId = memberService.join(member);

    //then
    assertEquals(member, memberService.findOne(memberId));
  }
  
  @Test(expected = IllegalStateException.class)
  public void 이메일중복() throws Exception {
      //given
    Member member1 = new Member();
    member1.setAccount_id(Member.makeRandomString(16));
    member1.setEmail("koting@test.krr");

    Member member2 = new Member();
    member2.setAccount_id(Member.makeRandomString(16));
    member2.setEmail("koting@test.krr");

      //when
    memberService.join(member1);
    memberService.join(member2);

      //then
    fail();
  }

  @Test(expected = IllegalStateException.class)
  public void 휴대폰번호중복() throws Exception {
    //given
    Member member1 = new Member();
    member1.setAccount_id(Member.makeRandomString(16));
    member1.setNumber("010123456788");

    Member member2 = new Member();
    member2.setAccount_id(Member.makeRandomString(16));
    member2.setNumber("010123456788");

    //when
    memberService.join(member1);
    memberService.join(member2);

    //then
    fail();
  }
}