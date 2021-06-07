package com.teambB.koting.repository;

import com.teambB.koting.domain.ReportMeeting;
import javax.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
@RequiredArgsConstructor
@Transactional
public class ReportMeetingRepository {

  private final EntityManager em;

  public void save(ReportMeeting reportMeeting) {
    if (reportMeeting.getId() == null) {
      em.persist(reportMeeting);
    } else {
      em.merge(reportMeeting);
    }
  }
}
