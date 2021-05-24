package com.teambB.koting.domain;

import static com.teambB.koting.domain.ApplyStatus.*;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter @Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Apply {

  @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "apply_id")
  private Long id;

  @Enumerated(EnumType.STRING)
  private ApplyStatus applyStatus;

  @ManyToOne(cascade = CascadeType.ALL)
  @JoinColumn(name = "meeting_id")
  private Meeting meeting;

  @ManyToOne(cascade = CascadeType.ALL)
  @JoinColumn(name = "member_id")
  private Member member;
  private LocalDateTime createDate;

  public void setMember(Member member) {
    this.member = member;
    member.getApplies().add(this);
  }

  public void setMeeting(Meeting meeting) {
    this.meeting = meeting;
    meeting.getParticipants().add(this);
    meeting.addApplierCnt();
  }

  public static Apply createApply(Member member, Meeting meeting) {
    Apply apply = new Apply();
    apply.setMeeting(meeting);
    apply.setMember(member);
    apply.setApplyStatus(WAIT);
    ZonedDateTime nowUTC = ZonedDateTime.now(ZoneId.of("UTC"));
    LocalDateTime nowSeoul = nowUTC.withZoneSameInstant(ZoneId.of("Asia/Seoul")).toLocalDateTime();
    apply.setCreateDate(nowSeoul);
    return apply;
  }

  public void applyAccept() {
    this.applyStatus = ACCEPT;
  }

  public void rejectAccept() {
    this.applyStatus = REJECT;
  }
}
