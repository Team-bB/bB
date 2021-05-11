package com.teambB.koting.repository;

import com.teambB.koting.domain.Apply;
import com.teambB.koting.domain.ApplyStatus;
import com.teambB.koting.domain.Meeting;
import java.util.List;
import javax.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
@RequiredArgsConstructor
@Transactional
public class ApplyRepository {

  private final EntityManager em;

  public void save(Apply apply) {
    if (apply.getId() == null) {
      em.persist(apply);
    } else {
      em.merge(apply);
    }
  }

  public Apply findOne(Long id) {
    return em.find(Apply.class, id);
  }

  public List<Apply> findAll() {
    return em.createQuery("select a from Apply a where a.applyStatus = :ACCEPT", Apply.class)
        .setParameter("ACCEPT", ApplyStatus.ACCEPT)
        .getResultList();
  }
}
