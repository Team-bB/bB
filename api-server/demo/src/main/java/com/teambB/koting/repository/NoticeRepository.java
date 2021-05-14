package com.teambB.koting.repository;

import com.teambB.koting.domain.Notice;
import java.util.List;
import javax.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
@Transactional
@RequiredArgsConstructor
public class NoticeRepository {

  private final EntityManager em;

  public void save(Notice notice) {
    if (notice.getId() == null) {
      em.persist(notice);
    } else {
      em.merge(notice);
    }
  }

  public Notice findOne(Long id) {
    return em.find(Notice.class, id);
  }

  public List<Notice> findAll() {
    return em.createQuery("select n from Notice n", Notice.class)
        .getResultList();
  }
}
