package com.teambB.koting.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ViewController {

  @GetMapping("/index")
  public String testPage() {
    return "index";
  }
}
