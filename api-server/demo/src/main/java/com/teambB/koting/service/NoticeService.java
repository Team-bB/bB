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

  public List<Notice> findAll() {
    return noticeRepository.findAll();
  }
}
