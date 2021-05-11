package com.teambB.koting.controller;

import com.teambB.koting.domain.Notice;
import com.teambB.koting.service.NoticeService;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
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
    for (Notice notice : all) {
      JSONObject temp = new JSONObject();
      temp.put("id", notice.getId());
      temp.put("title", notice.getTitle());
      temp.put("content", notice.getContent());
      temp.put("date", notice.getDate());
      array.add(temp);
    }
    retObect.put("notice", array);
    return retObect;
  }
}
