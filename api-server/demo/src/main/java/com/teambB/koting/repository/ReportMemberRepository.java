package com.teambB.koting.repository;

import com.teambB.koting.domain.ReportMeeting;
import com.teambB.koting.domain.ReportMember;
import javax.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
@RequiredArgsConstructor
@Transactional
public class ReportMemberRepository {

  private final EntityManager em;

  public void save(ReportMember reportMember) {
    if (reportMember.getId() == null) {
      em.persist(reportMember);
    } else {
      em.merge(reportMember);
    }
  }
}
