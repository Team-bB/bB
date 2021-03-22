package com.teambB.koting.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class WebController {

  @GetMapping("/index")
  public String introPage() {
    return "index";
  }
}
