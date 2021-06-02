package com.teambB.koting.service;

import com.teambB.koting.domain.Apply;
import com.teambB.koting.domain.Meeting;
import com.teambB.koting.domain.Member;
import com.teambB.koting.repository.ApplyRepository;
import com.teambB.koting.repository.MeetingRepository;
import com.teambB.koting.repository.MemberRepository;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional
public class ApplyService {

  private final MemberRepository memberRepository;
  private final ApplyRepository applyRepository;
  private final MeetingRepository meetingRepository;

  public Long join(Apply apply) {
    validateApply(apply);
    applyRepository.save(apply);
    return apply.getId();
  }

  public Integer applyNotAvailable(String accountId, Long meetingId) {
    Member member = memberRepository.findByAccountId(accountId);
    Meeting meeting = meetingRepository.findById(meetingId);

    // 거절된 미팅
    List<Apply> apply = applyRepository.findByMemberId(meetingId, member.getId());
    if (!apply.isEmpty()) {
      return 1;
    }
    // 이미 신청한 미청
    for (Apply myApply : member.getApplies()) {
      if (myApply.getMeeting().getId() == meetingId) {
        return 2;
      }
    }
    // 3명 이상 찼을 경우
    if (meeting.getApplierCnt() >= 3)
      return 3;
    return 0;
  }

  public Long Apply(String accountId, Long meetingId) {
    Member member = memberRepository.findByAccountId(accountId);
    Meeting meeting = meetingRepository.findById(meetingId);
    Apply apply = Apply.createApply(member, meeting);
    Long applyId = join(apply);
    return applyId;
  }

  private void validateApply(Apply apply) {
    String owner = memberRepository.findOne(apply.getMeeting().getMemberId()).getAccount_id();
    String applier = apply.getMember().getAccount_id();
    if (owner.equals(applier)) {
      throw new IllegalStateException("본인에게 신청할 수 없습니다.");
    }
  }

  @Transactional(readOnly = true)
  public Apply findOne(Long id) {
    return applyRepository.findOne(id);
  }

  @Transactional(readOnly = true)
  public List<Apply> findAllAccept() {
    return applyRepository.findAllAccept();
  }

  @Transactional(readOnly = true)
  public List<Apply> findAll() {
    return applyRepository.findAll();
  }
}
