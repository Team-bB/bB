package com.teambB.koting.controller;

import com.teambB.koting.service.NoticeService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@Controller
public class WebController {

  @GetMapping("/index")
  public String introPage() {
    return "index";
  }
}
