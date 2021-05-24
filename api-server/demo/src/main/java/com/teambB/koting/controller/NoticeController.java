package com.teambB.koting.controller;

import com.teambB.koting.domain.Notice;
import com.teambB.koting.service.NoticeService;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
public class NoticeController {

  @Autowired private final NoticeService noticeService;

  @GetMapping("/notice")
  public JSONObject getNotice() {
    JSONObject retObect = new JSONObject();
    JSONArray array = new JSONArray();

    List<Notice> all = noticeService.findAll();
    Collections.reverse(all);
    for (Notice notice : all) {
      JSONObject temp = new JSONObject();
      temp.put("id", notice.getId());
      temp.put("title", notice.getTitle());
      temp.put("content", notice.getContent());
      temp.put("date", notice.getCreateDatetime().format(DateTimeFormatter.ISO_DATE));
      array.add(temp);
    }
    retObect.put("notice", array);
    return retObect;
  }

  @PostMapping("/notice")
  public void createNotice(@RequestBody JSONObject object) {
    noticeService.join(
        Notice.createNotice(object.get("title").toString(), object.get("content").toString()));
  }
}
