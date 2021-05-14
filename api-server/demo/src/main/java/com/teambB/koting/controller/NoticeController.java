package com.teambB.koting.controller;

import com.teambB.koting.domain.Notice;
import com.teambB.koting.service.NoticeService;
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
    for (int i = all.size() - 1; i >= 0; i--) {
      JSONObject temp = new JSONObject();
      temp.put("id", all.get(i).getId());
      temp.put("title", all.get(i).getTitle());
      temp.put("content", all.get(i).getContent());
      temp.put("date", all.get(i).getCreateDate());
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
