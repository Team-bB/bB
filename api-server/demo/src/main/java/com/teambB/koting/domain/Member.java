package com.teambB.koting.domain;

import java.util.ArrayList;
import java.util.List;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter @Setter
public class Member {

  @Id @GeneratedValue
  @Column(name = "member_id")
  private Long id;

  private String college;
  private String subject;
  private int height;
  private int age;
  private String mbti;
  private String email;
  private String number;

  @OneToOne
  @JoinColumn(name = "creation_id")
  private Creation myMeeting;

  @OneToMany(mappedBy = "member")
  private List<Order> meetings = new ArrayList<>();


}
