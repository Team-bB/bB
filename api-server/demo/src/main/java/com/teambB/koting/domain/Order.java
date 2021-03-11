package com.teambB.koting.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter @Setter
@Table(name = "orders")
public class Order {
  @Id @GeneratedValue
  @Column(name = "order_id")
  private Long id;

  @ManyToOne
  @JoinColumn(name = "meeting_id")
  private Meeting meeting;

  @ManyToOne
  @JoinColumn(name = "member_id")
  private Member member;
}
