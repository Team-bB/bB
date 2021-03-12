package com.teambB.koting.repository;

import java.util.List;
import com.teambB.koting.domain.Meeting;
import javax.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class MeetingRepository {
  private final EntityManager em;

  public void save(Meeting meeting) {
    if (meeting.getId() == null) {
      em.persist(meeting);
    } else {
      em.merge(meeting);
    }
  }

  public Meeting findOne(Long id) {
    return em.find(Meeting.class, id);
  }

  public List<Meeting> findAll() {
    return em.createQuery("select m from Meeting m", Meeting.class)
        .getResultList();
  }
}
