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

  public Long join(Member member) {
    validateMember(member);
    memberRepository.save(member);
    return member.getId();
  }

  private void validateMember(Member member) {
    List<Member> findNumbers = memberRepository.findByNumberList(member.getNumber());
    if (!findNumbers.isEmpty()) {
      throw new IllegalStateException("이미 존재하는 회원입니다.");
    }
  }

  public Member findOne(Long id) {
    return memberRepository.findById(id);
  }

  public Member findOneByEmail(String email) {
    return memberRepository.findByEmail(email);
  }

  public Member findOneByNumber(String number) {
    return memberRepository.findByNumber(number);
  }

  public Member findOneByAccountId(String accountId) {
    return memberRepository.findByAccountId(accountId);
  }
}
