package com.teambB.koting.repository;

import java.util.List;
import com.teambB.koting.domain.Meeting;
import javax.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
@RequiredArgsConstructor
@Transactional
public class MeetingRepository {

  private final EntityManager em;

  public void save(Meeting meeting) {
    if (meeting.getId() == null) {
      em.persist(meeting);
    } else {
      em.merge(meeting);
    }
  }

  public Meeting findById(Long id) {
    return em.find(Meeting.class, id);
  }

  public List<Meeting> findAll() {
    return em.createQuery("select m from Meeting m", Meeting.class)
        .getResultList();
  }

  public List<Meeting> findByMemberId(Long memberId) {
    return em.createQuery("select m from Meeting m where m.memberId = :id", Meeting.class)
        .setParameter("id", memberId)
        .getResultList();
  }
}
