package com.teambB.koting.controller;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class testController {

  @PostMapping("/test")
  public String testMapping() {
    return "success";
  }
}
