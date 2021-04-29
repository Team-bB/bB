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
import javax.persistence.OneToOne;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter @Setter
public class Meeting {

  @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "meeting_id")
  private Long id;

  private LocalDateTime createDate;
  private String player;
  private String link;

  @Enumerated(EnumType.STRING)
  private MeetingStatus meetingStatus;

  @OneToOne(mappedBy = "myMeeting")
  private Member owner;

  @OneToMany(mappedBy = "meeting")
  private List<Apply> participants = new ArrayList<>();

  public static Meeting createMeeting(Member member, String player, String link) {

    Meeting meeting = new Meeting();
    meeting.setOwner(member);
    meeting.setPlayer(player);
    meeting.setCreateDate(LocalDateTime.now());
    meeting.setLink(link);
    meeting.setMember(member);
    meeting.setMeetingStatus(MeetingStatus.READY);
    return meeting;
  }

  public void setMember(Member member) {
    this.owner = member;
    member.setMyMeeting(this);
  }
}
