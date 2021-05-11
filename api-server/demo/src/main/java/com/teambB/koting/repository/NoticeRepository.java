package com.teambB.koting.repository;

import com.teambB.koting.domain.Meeting;
import com.teambB.koting.domain.Member;
import com.teambB.koting.domain.Notice;
import java.util.List;
import javax.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
@RequiredArgsConstructor
@Transactional
public class NoticeRepository {

  private final EntityManager em;

  public void save(Notice notice) {
    if (notice.getId() == null) {
      em.persist(notice);
    } else {
      em.merge(notice);
    }
  }

  public List<Notice> findAll() {
    return em.createQuery("select n from Notice n", Notice.class)
        .getResultList();
  }

}
