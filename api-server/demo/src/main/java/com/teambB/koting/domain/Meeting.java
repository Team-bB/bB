package com.teambB.koting.domain;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
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

  private int player;
  private LocalDateTime createDate;

  @Enumerated(EnumType.STRING)
  private MeetingStatus meeting_status;

  @OneToOne(mappedBy = "myMeeting")
  private Member owner;

  @OneToMany(mappedBy = "meeting")
  private List<Apply> participants = new ArrayList<>();

  public static Meeting createMeeting(Member member, int player) {
    Meeting meeting = new Meeting();
    meeting.setOwner(member);
    meeting.setPlayer(player);
    LocalDateTime date = LocalDateTime.now();
    meeting.setCreateDate(date);
    meeting.setMeeting_status(MeetingStatus.READY);
    return meeting;
  }
}
