package com.teambB.koting.repository;

import com.teambB.koting.domain.Apply;
import com.teambB.koting.domain.ApplyStatus;
import com.teambB.koting.domain.Member;
import java.util.List;
import java.util.Optional;
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

  public List<Apply> findAllAccept() {
    return em.createQuery("select a from Apply a where a.applyStatus = :ACCEPT", Apply.class)
        .setParameter("ACCEPT", ApplyStatus.ACCEPT)
        .getResultList();
  }

  public List<Apply> findAll() {
    return em.createQuery("select a from Apply a", Apply.class)
        .getResultList();
  }

  public List<Apply> findByMemberId(Long meetingId, Long memberId) {
    return em.createQuery("select a from Apply a where a.meeting.id = :meetingId and a.member.id = :memberId and a.applyStatus = :status", Apply.class)
        .setParameter("meetingId", meetingId)
        .setParameter("memberId", memberId)
        .setParameter("status", ApplyStatus.REJECT)
        .getResultList();
  }

  public List<Apply> findAllByMemberId(Long memberId) {
    return em.createQuery("select a from Apply a where a.member.id = :memberId", Apply.class)
        .setParameter("memberId", memberId)
        .getResultList();
  }

  public List<Apply> findAllByMeetingId(Long meetingId) {
    return em.createQuery("select a from Apply a where a.meeting.id = :meetingId", Apply.class)
        .setParameter("meetingId", meetingId)
        .getResultList();
  }

}
