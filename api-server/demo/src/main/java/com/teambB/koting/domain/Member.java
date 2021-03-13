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
import org.json.simple.JSONObject;

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
  @JoinColumn(name = "owner")
  private Meeting myMeeting;

  @OneToMany(mappedBy = "member")
  private List<Apply> meetings = new ArrayList<>();

  public static Member createMember(JSONObject object) {
    Member member = new Member();
    /*
    member.setCollege(object.get("college").toString());
    member.setSubject(object.get("subject").toString());
    member.setHeight(Integer.parseInt(object.get("height").toString()));
    member.setAge(Integer.parseInt(object.get("college").toString()));
    member.setMbti(object.get("mbti").toString());
    member.setEmail(object.get("email").toString());
     */
    member.setNumber(object.get("number").toString());
    return member;
  }
}
