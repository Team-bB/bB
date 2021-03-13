package com.teambB.koting.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter @Setter
public class Apply {

  @Id @GeneratedValue
  @Column(name = "apply_id")
  private Long id;

  @ManyToOne
  @JoinColumn(name = "meeting_id")
  private Meeting meeting;

  @ManyToOne
  @JoinColumn(name = "member_id")
  private Member member;

  // 생성 메서드
  public static Apply createApply(Member member, Meeting meeting) {
    Apply apply = new Apply();
    apply.setMember(member);
    apply.setMeeting(meeting);
    return apply;
  }
}
