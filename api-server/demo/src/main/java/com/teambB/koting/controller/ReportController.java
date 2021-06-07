package com.teambB.koting.controller;

import com.teambB.koting.domain.ReportMeeting;
import com.teambB.koting.domain.ReportMember;
import com.teambB.koting.repository.ReportMeetingRepository;
import com.teambB.koting.repository.ReportMemberRepository;
import com.teambB.koting.service.MeetingService;
import lombok.RequiredArgsConstructor;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class ReportController {

  @Autowired private final MeetingService meetingService;
  @Autowired private final ReportMemberRepository reportMemberRepository;
  @Autowired private final ReportMeetingRepository reportMeetingRepository;

  @PostMapping("/report/meeting")
  public JSONObject reportMeeting(@RequestBody JSONObject object) {
    JSONObject retObject = new JSONObject();

    String accountId = object.get("account_id").toString();
    Long meetingId = Long.parseLong(object.get("meeting_id").toString());
    String category = object.get("category").toString();
    String content = meetingService.findOne(meetingId).getLink();
    ReportMeeting reportMeeting = ReportMeeting.createReportMeeting(accountId, meetingId, category, content);
    reportMeetingRepository.save(reportMeeting);

    retObject.put("result", "true");
    return retObject;
  }

  @PostMapping("/report/member")
  public JSONObject reportMember(@RequestBody JSONObject object) {
    JSONObject retObject = new JSONObject();

    String myAccountId = object.get("myAccount_id").toString();
    String yourAccountId = object.get("yourAccount_id").toString();
    String category = object.get("category").toString();
    ReportMember reportMember = ReportMember.createReportMember(myAccountId, yourAccountId, category);
    reportMemberRepository.save(reportMember);

    retObject.put("result", "true");
    return retObject;
  }
}
