package com.teambB.koting.controller;

import com.teambB.koting.domain.Member;
import com.teambB.koting.domain.ReportMeeting;
import com.teambB.koting.domain.ReportMember;
import com.teambB.koting.repository.MemberRepository;
import com.teambB.koting.repository.ReportMeetingRepository;
import com.teambB.koting.repository.ReportMemberRepository;
import com.teambB.koting.service.MeetingService;
import com.teambB.koting.service.MemberService;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequiredArgsConstructor
public class ReportController {

  @Autowired private final MeetingService meetingService;
  @Autowired private final ReportMemberRepository reportMemberRepository;
  @Autowired private final ReportMeetingRepository reportMeetingRepository;
  @Autowired private final MemberService memberService;
  @Autowired private final MemberRepository memberRepository;

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

    String myAccountId = object.get("my_account_id").toString();
    String yourAccountId = object.get("your_account_id").toString();
    String category = object.get("category").toString();
    ReportMember reportMember = ReportMember.createReportMember(myAccountId, yourAccountId, category);
    reportMemberRepository.save(reportMember);

    retObject.put("result", "true");
    return retObject;
  }

  @Transactional
  @PostMapping("/block")
  public JSONObject blockMember(@RequestBody JSONObject object) {
    JSONObject retObject = new JSONObject();

    String myAccountId = object.get("my_account_id").toString();
    String yourAccountId = object.get("your_account_id").toString();

    memberService.addBlockMember(myAccountId, yourAccountId);
    retObject.put("result", "true");
    return retObject;
  }

  @GetMapping("/block")
  public void getBlockMember(@RequestParam("account_id") String accountId) {
    Member member = memberRepository.findByAccountId(accountId);
    List<Long> block = member.getBlock();
    for (Long id : block) {
      log.info("block id = {}", id);
    }
  }
}
