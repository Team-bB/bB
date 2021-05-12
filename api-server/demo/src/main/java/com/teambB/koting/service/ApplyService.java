package com.teambB.koting.service;

import com.teambB.koting.domain.Apply;
import com.teambB.koting.domain.Meeting;
import com.teambB.koting.domain.Member;
import com.teambB.koting.repository.ApplyRepository;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional
public class ApplyService {

  private final ApplyRepository applyRepository;

  public Long join(Apply apply) {
    validateApply(apply);
    applyRepository.save(apply);
    return apply.getId();
  }

  private void validateApply(Apply apply) {
    String owner = apply.getMeeting().getOwner().getAccount_id();
    String applier = apply.getMember().getAccount_id();
    if (owner.equals(applier)) {
      throw new IllegalStateException("본인에게 신청할 수 없습니다.");
    }
  }

  @Transactional(readOnly = true)
  public Apply findOne(Long id) {
    return applyRepository.findOne(id);
  }

  public List<Apply> findAll() {
    return applyRepository.findAll();
  }
}
