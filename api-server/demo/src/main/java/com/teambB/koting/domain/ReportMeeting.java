package com.teambB.koting.domain;

import com.teambB.koting.service.MeetingService;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter @Setter
public class ReportMeeting {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "report_meeting_id")
  private Long id;

  private String accountId;
  private Long meetingId;
  private String category;
  private String content;

  public static ReportMeeting createReportMeeting(String accountId, Long meetingId, String category, String content) {

    ReportMeeting reportMeeting = new ReportMeeting();

    reportMeeting.accountId = accountId;
    reportMeeting.meetingId = meetingId;
    reportMeeting.category = category;
    reportMeeting.content = content;

    return reportMeeting;
  }

}
