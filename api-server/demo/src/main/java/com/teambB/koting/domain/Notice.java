package com.teambB.koting.domain;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter @Setter
public class Notice {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "notice_id")
  private Long id;

  @Column(columnDefinition = "LONGTEXT")
  private String title;

  @Column(columnDefinition = "LONGTEXT")
  private String content;

  private LocalDate createDate;

  public static Notice createNotice(String title, String content) {
    Notice notice = new Notice();
    notice.setTitle(title);
    notice.setContent(content);
    notice.setCreateDate(LocalDate.now());
    return notice;
  }
}
