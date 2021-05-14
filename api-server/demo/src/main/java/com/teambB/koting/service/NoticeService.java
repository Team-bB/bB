package com.teambB.koting.service;

import com.teambB.koting.domain.Notice;
import com.teambB.koting.repository.NoticeRepository;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
@RequiredArgsConstructor
public class NoticeService {
  private final NoticeRepository noticeRepository;

  public Long join(Notice notice) {
    noticeRepository.save(notice);
    return notice.getId();
  }

  @Transactional(readOnly = true)
  public Notice findOne(Long id) {
    return noticeRepository.findOne(id);
  }

  public List<Notice> findAll() {
    return noticeRepository.findAll();
  }
}
