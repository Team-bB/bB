package com.teambB.koting.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter @Setter
public class ReportMember {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "report_member_id")
  private Long id;

  private String myAccountId;
  private String yourAccountId;
  private String category;

  public static ReportMember createReportMember(String myAccountId, String yourAccountId, String category) {

    ReportMember reportMember = new ReportMember();

    reportMember.myAccountId = myAccountId;
    reportMember.yourAccountId = yourAccountId;
    reportMember.category = category;

    return reportMember;
  }
}
