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
public class ItemList {
  @Id
  @GeneratedValue
  @Column(name = "itemlist_id")
  private Long id;

  @ManyToOne
  @JoinColumn(name = "item_id")
  private Item item;
}
