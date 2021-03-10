package com.teambB.koting.repository;

import static org.assertj.core.api.Assertions.assertThat;

import com.teambB.koting.domain.Member;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.transaction.annotation.Transactional;

@RunWith(SpringRunner.class)
@SpringBootTest
public class MemberRepositoryTest {
  @Autowired MemberRepository memberRepository;

  @Test
  @Transactional
  @Rollback(false)
  public void testMember() throws Exception {
      //given
    Member member1 = new Member();
    member1.setNumber("010-1234-5678");

      //when
    Long saveId = memberRepository.save(member1);
    Member findMember = memberRepository.find(saveId);

      //then
    assertThat(findMember.getId()).isEqualTo(member1.getId());
    assertThat(findMember.getNumber()).isEqualTo(member1.getNumber());
  }
}