package com.teambB.koting.domain;

import java.time.LocalDateTime;
import java.util.List;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter @Setter
public class Meeting {
  @Id @GeneratedValue
  @Column(name = "meeting_id")
  private Long id;

  private int player;
  private LocalDateTime createDate;

  @Enumerated(EnumType.STRING)
  private MeetingStatus meeting_status;

  @OneToOne
  @JoinColumn(name = "creation_id")
  private Creation owner;

  @OneToMany(mappedBy = "meeting")
  private List<Order> participants;


}
