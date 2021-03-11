package com.teambB.koting.repository;

import com.teambB.koting.domain.Member;
import java.util.List;
import javax.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class MemberRepository {

  private final EntityManager em;

  public void save(Member member) {
    em.persist(member);
  }

  public Member findById(Long id) {
    return em.find(Member.class, id);
  }

  public Member findByNumber(String number) {
    return em.find(Member.class, number);
  }

  public List<Member> findAll() {
    return em.createQuery("select m from Member m", Member.class)
        .getResultList();
  }

  public List<Member> findByNumberList(String number) {
    return em.createQuery("select m from Member m where m.number = :number", Member.class)
        .setParameter("number", number)
        .getResultList();
  }
}
