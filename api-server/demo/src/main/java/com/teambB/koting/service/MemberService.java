package com.teambB.koting.service;

import com.teambB.koting.domain.Member;
import com.teambB.koting.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
@RequiredArgsConstructor
public class MemberService {

  private final MemberRepository memberRepository;

  // 회원가입
  public Long join(Member member) {
    validateMember(member);
    memberRepository.save(member);
    return member.getId();
  }

  // 중복 회원 검사
  private void validateMember(Member member) {
    List<Member> findNumbers = memberRepository.findByNumberList(member.getNumber());
    if (!findNumbers.isEmpty()) {
      throw new IllegalStateException("이미 존재하는 회원입니다.");
    }
  }

  // 회원 번호로 조회
  @Transactional(readOnly = true)
  public Member findOne(String number) {
    return memberRepository.findByNumber(number);
  }
}