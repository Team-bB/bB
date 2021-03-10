package com.teambB.koting.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter @Setter
public class Item {
  @Id @GeneratedValue
  @Column(name = "item_id")
  private Long id;

  @ManyToOne
  @JoinColumn(name = "member_id")
  private Member member;
}
