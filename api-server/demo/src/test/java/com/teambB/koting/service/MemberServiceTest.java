package com.teambB.koting.service;

import static org.junit.Assert.*;

import com.teambB.koting.domain.Member;
import com.teambB.koting.repository.MemberRepository;
import javax.persistence.EntityManager;
import org.junit.Assert;
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

public class MemberServiceTest {
  @Autowired MemberService memberService;
  @Autowired MemberRepository memberRepository;

  @Test
  public void 회원가입() throws Exception {
      //given
    Member member = new Member();
    member.setNumber("010-5795-2740");

      //when
    Long savedId = memberService.join(member);

      //then
    assertEquals(member, memberRepository.findById(savedId));
  }

 @Test
 public void 중복_회원가입() throws Exception {
     //given
   Member member1 = new Member();
   member1.setNumber("010-5795-2740");

   Member member2 = new Member();
   member2.setNumber("010-5795-2740");

     //when
   memberService.join(member1);
   try {
     memberService.join(member2);
   } catch (IllegalStateException e) {
     return ;
   }
     //then
   fail("예외가 발생해야 합니다.");
 }
          
}