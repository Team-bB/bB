package com.teambB.koting.domain;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter @Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Meeting {

  @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "meeting_id")
  private Long id;
  private Integer applierCnt;
  private Long memberId;
  private LocalDateTime createDate;
  private String player;
  private String link;

  @Enumerated(EnumType.STRING)
  private MeetingStatus meetingStatus;

  @OneToMany(mappedBy = "meeting")
  private List<Apply> participants = new ArrayList<>();

  public void addApplierCnt() {
    this.applierCnt += 1;
  }

  public void minusApplierCnt() {
    this.applierCnt -= 1;
  }

  public static Meeting createMeeting(Member member, String player, String link) {
    Meeting meeting = new Meeting();
    meeting.setPlayer(player);
    meeting.setApplierCnt(0);
    meeting.setMeetingStatus(MeetingStatus.OPEN);
    meeting.setCreateDate(LocalDateTime.now());
    meeting.setLink(link);
    meeting.setMemberId(member.getId());
    return meeting;
  }
}
