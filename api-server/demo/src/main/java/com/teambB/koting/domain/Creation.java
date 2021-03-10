package com.teambB.koting.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.OneToOne;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter @Setter
public class Creation {
  @Id @GeneratedValue
  @Column(name = "creation_id")
  private Long id;

  @OneToOne(mappedBy = "owner")
  private Meeting meeting;

  @OneToOne(mappedBy = "myMeeting")
  private Member member;
}
