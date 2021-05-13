package com.teambB.koting.domain;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter @Setter
public class Meeting {

  @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "meeting_id")
  private Long id;
  private Long ownerId;
  private LocalDateTime createDate;
  private String player;
  private String link;

  @OneToMany(mappedBy = "meeting")
  private List<Apply> participants = new ArrayList<>();

  public static Meeting createMeeting(Member member, String player, String link) {
    Meeting meeting = new Meeting();
    meeting.setPlayer(player);
    meeting.setCreateDate(LocalDateTime.now());
    meeting.setLink(link);
    meeting.setOwnerId(member.getId());
    return meeting;
  }
}
