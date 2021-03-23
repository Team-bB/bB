package com.teambB.koting.domain;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter @Setter
public class Apply {

  @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "apply_id")
  private Long id;

  @ManyToOne(cascade = CascadeType.ALL)
  @JoinColumn(name = "meeting_id")
  private Meeting meeting;

  @ManyToOne(cascade = CascadeType.ALL)
  @JoinColumn(name = "member_id")
  private Member member;

  public void setMember(Member member) {
    this.member = member;
    member.getApplies().add(this);
  }

  public void setMeeting(Meeting meeting) {
    this.meeting = meeting;
    meeting.getParticipants().add(this);
  }

  public static Apply createApply(Member member, Meeting meeting) {
    Apply apply = new Apply();
    apply.setMeeting(meeting);
    apply.setMember(member);
    return apply;
  }
}
