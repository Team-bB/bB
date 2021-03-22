package com.teambB.koting.service;

import com.teambB.koting.domain.Apply;
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

  private final ApplyRepository applyRepository;

  public Long join(Apply apply) {
    applyRepository.save(apply);
    return apply.getId();
  }

  @Transactional(readOnly = true)
  public Apply findOne(Long id) {
    return applyRepository.findOne(id);
  }
}
