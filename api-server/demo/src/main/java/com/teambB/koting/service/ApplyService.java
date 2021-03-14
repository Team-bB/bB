package com.teambB.koting.service;

import com.teambB.koting.domain.Apply;
import com.teambB.koting.domain.Meeting;
import com.teambB.koting.domain.Member;
import com.teambB.koting.repository.ApplyRepository;
import com.teambB.koting.repository.MeetingRepository;
import com.teambB.koting.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional
public class ApplyService {

  private final MeetingRepository meetingRepository;
  private final MemberRepository memberRepository;
  private final ApplyRepository applyRepository;

  public Long join(Apply apply) {
    applyRepository.save(apply);
    return apply.getId();
  }

  @Transactional(readOnly = true)
  public Apply findOne(Long id) {
    return applyRepository.findById(id);
  }

  public Long apply(Long memberId, Long meetingId) {
    Member member = memberRepository.findById(memberId);
    Meeting meeting = meetingRepository.findById(meetingId);

    Apply apply = Apply.createApply(member, meeting);
    applyRepository.save(apply);
    return apply.getId();
  }
}
