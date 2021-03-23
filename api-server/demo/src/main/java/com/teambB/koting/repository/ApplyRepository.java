package com.teambB.koting.repository;

import com.teambB.koting.domain.Apply;
import javax.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
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
}
