package com.teambB.koting.domain;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import lombok.Getter;
import lombok.Setter;
import org.json.simple.JSONObject;

@Entity
@Getter @Setter
public class Member {

  @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "member_id")
  private Long id;

  private Long myMeetingId;

  private String account_id;
  private String sex;
  private String college;
  private String major;
  private int height;
  private int age;
  private String mbti;
  private String email;
  private String number;
  private int animalIdx;
  private String authKey;
  private Boolean authStatus;

  @OneToMany(mappedBy = "member")
  private List<Apply> applies = new ArrayList<>();

  public static Member createMember(JSONObject object) {

    Member member = new Member();
    member.setAccount_id(member.makeRandomString(16));
    member.setSex(object.get("sex").toString());
    member.setCollege(object.get("college").toString());
    member.setMajor(object.get("major").toString());
    member.setHeight(Integer.parseInt(object.get("height").toString()));
    member.setAge(Integer.parseInt(object.get("age").toString()));
    member.setMbti(object.get("mbti").toString());
    member.setEmail(object.get("email").toString());
    member.setNumber(object.get("phoneNumber").toString());
    member.setAnimalIdx(Integer.parseInt(object.get("animalIdx").toString()));
    member.setAuthKey(makeRandomString(8));
    member.setAuthStatus(false);
    return member;
  }

  public static String makeRandomString(int length) {

    StringBuffer buffer = new StringBuffer();
    Random random = new Random();

    String chars[] = "a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,1,2,3,4,5,6,7,8,9".split(",");

    for (int i = 0; i < length; i++) {
      buffer.append(chars[random.nextInt(chars.length)]);
    }
    return buffer.toString();
  }

  public static String makeRandomNumber(int length) {

    String numStr = "";
    Random rand = new Random();
    for (int i = 0; i < length; i++) {
      numStr += Integer.toString(rand.nextInt(10));
    }
    return numStr;
  }
}
