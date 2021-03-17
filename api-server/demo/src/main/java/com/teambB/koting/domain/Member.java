package com.teambB.koting.domain;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
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

  @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "member_id")
  private Long id;

  private String college;
  private String subject;
  private String height;
  private String age;
  private String mbti;
  private String email;
  private String number;
  private String authKey;
  private Boolean authStatus;

  @OneToOne
  @JoinColumn(name = "meeting_id")
  private Meeting myMeeting;

  @OneToMany(mappedBy = "member")
  private List<Apply> applies = new ArrayList<>();

  public static Member createMember(JSONObject object, String authKey) {

    Member member = new Member();
    member.setCollege(object.get("college").toString());
    member.setSubject(object.get("subject").toString());
    member.setHeight(object.get("height").toString());
    member.setAge(object.get("age").toString());
    member.setMbti(object.get("mbti").toString());
    member.setEmail(object.get("email").toString());
    member.setNumber(object.get("number").toString());
    member.setAuthStatus(false);
    member.setAuthKey(authKey);
    return member;
  }

  public String makeRandomString(int length) {

    StringBuffer buffer = new StringBuffer();
    Random random = new Random();

    String chars[] = "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,1,2,3,4,5,6,7,8,9".split(",");

    for (int i = 0; i < length; i++) {
      buffer.append(chars[random.nextInt(chars.length)]);
    }
    return buffer.toString();
  }
}
